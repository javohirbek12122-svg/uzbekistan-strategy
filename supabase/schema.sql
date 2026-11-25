-- Bilet 023 — dedicated project schema
-- Apply only to a dedicated Bilet 023 Supabase project.
-- Do NOT apply this schema to Yoshlar-Ishi or Parkent E-Market.

create table if not exists public.bilet023_tournaments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Yangi turnir' check (char_length(btrim(title)) between 2 and 120),
  region text not null default '',
  event_date date,
  description text not null default '',
  status text not null default 'draft' check (status in ('draft','published','archived')),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.bilet023_teams (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.bilet023_tournaments(id) on delete cascade,
  team_name text not null check (char_length(btrim(team_name)) between 1 and 80),
  wins integer not null default 0 check (wins between 0 and 999),
  draws integer not null default 0 check (draws between 0 and 999),
  losses integer not null default 0 check (losses between 0 and 999),
  played integer generated always as (wins + draws + losses) stored,
  points integer generated always as ((wins * 3) + draws) stored,
  sort_order smallint not null default 1 check (sort_order between 1 and 4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (tournament_id, sort_order)
);

alter table public.bilet023_tournaments
  add column if not exists region text not null default '',
  add column if not exists event_date date,
  add column if not exists description text not null default '',
  add column if not exists status text not null default 'draft',
  add column if not exists published_at timestamptz;

alter table public.bilet023_tournaments
  drop constraint if exists bilet023_tournaments_status_check;
alter table public.bilet023_tournaments
  add constraint bilet023_tournaments_status_check
  check (status in ('draft','published','archived'));

create table if not exists public.bilet023_members (
  tournament_id uuid not null references public.bilet023_tournaments(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','operator','auditor','viewer')),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (tournament_id,user_id)
);

create table if not exists public.bilet023_audit_log (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.bilet023_tournaments(id) on delete restrict,
  actor_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  before_data jsonb,
  after_data jsonb,
  created_at timestamptz not null default now()
);

create index if not exists bilet023_tournaments_owner_idx on public.bilet023_tournaments(owner_id,updated_at desc);
create index if not exists bilet023_teams_tournament_idx on public.bilet023_teams(tournament_id,sort_order);
create index if not exists bilet023_members_user_idx on public.bilet023_members(user_id,tournament_id);
create index if not exists bilet023_audit_tournament_time_idx on public.bilet023_audit_log(tournament_id,created_at desc);

create or replace function public.bilet023_can_read(p_tournament_id uuid)
returns boolean language sql stable security definer set search_path=public
as $$
  select exists(select 1 from public.bilet023_tournaments t where t.id=p_tournament_id and t.status='published')
  or exists(select 1 from public.bilet023_tournaments t where t.id=p_tournament_id and t.owner_id=(select auth.uid()))
  or exists(select 1 from public.bilet023_members m where m.tournament_id=p_tournament_id and m.user_id=(select auth.uid()));
$$;

create or replace function public.bilet023_can_edit(p_tournament_id uuid)
returns boolean language sql stable security definer set search_path=public
as $$
  select exists(select 1 from public.bilet023_tournaments t where t.id=p_tournament_id and t.owner_id=(select auth.uid()))
  or exists(select 1 from public.bilet023_members m where m.tournament_id=p_tournament_id and m.user_id=(select auth.uid()) and m.role in ('admin','operator'));
$$;

create or replace function public.bilet023_can_manage(p_tournament_id uuid)
returns boolean language sql stable security definer set search_path=public
as $$
  select exists(select 1 from public.bilet023_tournaments t where t.id=p_tournament_id and t.owner_id=(select auth.uid()))
  or exists(select 1 from public.bilet023_members m where m.tournament_id=p_tournament_id and m.user_id=(select auth.uid()) and m.role='admin');
$$;

create or replace function public.bilet023_can_audit(p_tournament_id uuid)
returns boolean language sql stable security definer set search_path=public
as $$
  select exists(select 1 from public.bilet023_tournaments t where t.id=p_tournament_id and t.owner_id=(select auth.uid()))
  or exists(select 1 from public.bilet023_members m where m.tournament_id=p_tournament_id and m.user_id=(select auth.uid()) and m.role in ('admin','auditor'));
$$;

revoke all on function public.bilet023_can_read(uuid) from public;
revoke all on function public.bilet023_can_edit(uuid) from public;
revoke all on function public.bilet023_can_manage(uuid) from public;
revoke all on function public.bilet023_can_audit(uuid) from public;
grant execute on function public.bilet023_can_read(uuid) to anon,authenticated;
grant execute on function public.bilet023_can_edit(uuid) to authenticated;
grant execute on function public.bilet023_can_manage(uuid) to authenticated;
grant execute on function public.bilet023_can_audit(uuid) to authenticated;

create or replace function public.bilet023_set_updated_at()
returns trigger language plpgsql set search_path=public
as $$ begin new.updated_at=now(); return new; end; $$;

drop trigger if exists bilet023_tournaments_updated_at on public.bilet023_tournaments;
create trigger bilet023_tournaments_updated_at before update on public.bilet023_tournaments
for each row execute function public.bilet023_set_updated_at();
drop trigger if exists bilet023_teams_updated_at on public.bilet023_teams;
create trigger bilet023_teams_updated_at before update on public.bilet023_teams
for each row execute function public.bilet023_set_updated_at();
drop trigger if exists bilet023_members_updated_at on public.bilet023_members;
create trigger bilet023_members_updated_at before update on public.bilet023_members
for each row execute function public.bilet023_set_updated_at();

create or replace function public.bilet023_write_audit()
returns trigger language plpgsql security definer set search_path=public
as $$
declare
  v_tournament_id uuid;
  v_entity_id uuid;
  v_before jsonb;
  v_after jsonb;
  v_action text;
begin
  if tg_table_name='bilet023_tournaments' then
    v_tournament_id:=coalesce((to_jsonb(new)->>'id')::uuid,(to_jsonb(old)->>'id')::uuid);
  else
    v_tournament_id:=coalesce((to_jsonb(new)->>'tournament_id')::uuid,(to_jsonb(old)->>'tournament_id')::uuid);
  end if;
  v_entity_id:=coalesce((to_jsonb(new)->>'id')::uuid,(to_jsonb(old)->>'id')::uuid);
  v_before:=case when tg_op in ('UPDATE','DELETE') then to_jsonb(old) else null end;
  v_after:=case when tg_op in ('INSERT','UPDATE') then to_jsonb(new) else null end;
  v_action:=lower(tg_op);
  if v_tournament_id is not null then
    insert into public.bilet023_audit_log(tournament_id,actor_id,action,entity_type,entity_id,before_data,after_data)
    values(v_tournament_id,auth.uid(),v_action,tg_table_name,v_entity_id,v_before,v_after);
  end if;
  if tg_op='DELETE' then return old; end if;
  return new;
end;
$$;
revoke all on function public.bilet023_write_audit() from public,anon,authenticated;

drop trigger if exists bilet023_teams_audit on public.bilet023_teams;
create trigger bilet023_teams_audit after insert or update or delete on public.bilet023_teams
for each row execute function public.bilet023_write_audit();
drop trigger if exists bilet023_tournaments_audit on public.bilet023_tournaments;
create trigger bilet023_tournaments_audit after update on public.bilet023_tournaments
for each row execute function public.bilet023_write_audit();
drop trigger if exists bilet023_members_audit on public.bilet023_members;
create trigger bilet023_members_audit after insert or update or delete on public.bilet023_members
for each row execute function public.bilet023_write_audit();

alter table public.bilet023_tournaments enable row level security;
alter table public.bilet023_teams enable row level security;
alter table public.bilet023_members enable row level security;
alter table public.bilet023_audit_log enable row level security;

drop policy if exists "Bilet023 owners can read tournaments" on public.bilet023_tournaments;
drop policy if exists "Bilet023 owners can create tournaments" on public.bilet023_tournaments;
drop policy if exists "Bilet023 owners can update tournaments" on public.bilet023_tournaments;
drop policy if exists "Bilet023 owners can delete tournaments" on public.bilet023_tournaments;
create policy "Bilet023 read permitted tournaments" on public.bilet023_tournaments for select using(public.bilet023_can_read(id));
create policy "Bilet023 owners create tournaments" on public.bilet023_tournaments for insert to authenticated with check(owner_id=(select auth.uid()));
create policy "Bilet023 managers update tournaments" on public.bilet023_tournaments for update to authenticated using(public.bilet023_can_manage(id)) with check(public.bilet023_can_manage(id));

drop policy if exists "Bilet023 owners can read teams" on public.bilet023_teams;
drop policy if exists "Bilet023 owners can create teams" on public.bilet023_teams;
drop policy if exists "Bilet023 owners can update teams" on public.bilet023_teams;
drop policy if exists "Bilet023 owners can delete teams" on public.bilet023_teams;
create policy "Bilet023 read permitted teams" on public.bilet023_teams for select using(public.bilet023_can_read(tournament_id));
create policy "Bilet023 operators create teams" on public.bilet023_teams for insert to authenticated with check(public.bilet023_can_edit(tournament_id));
create policy "Bilet023 operators update teams" on public.bilet023_teams for update to authenticated using(public.bilet023_can_edit(tournament_id)) with check(public.bilet023_can_edit(tournament_id));
create policy "Bilet023 operators delete teams" on public.bilet023_teams for delete to authenticated using(public.bilet023_can_edit(tournament_id));

drop policy if exists "Bilet023 members read permitted memberships" on public.bilet023_members;
drop policy if exists "Bilet023 managers add memberships" on public.bilet023_members;
drop policy if exists "Bilet023 managers update memberships" on public.bilet023_members;
drop policy if exists "Bilet023 managers remove memberships" on public.bilet023_members;
create policy "Bilet023 members read permitted memberships" on public.bilet023_members for select to authenticated
using(user_id=(select auth.uid()) or public.bilet023_can_manage(tournament_id) or public.bilet023_can_audit(tournament_id));
create policy "Bilet023 managers add memberships" on public.bilet023_members for insert to authenticated with check(public.bilet023_can_manage(tournament_id));
create policy "Bilet023 managers update memberships" on public.bilet023_members for update to authenticated using(public.bilet023_can_manage(tournament_id)) with check(public.bilet023_can_manage(tournament_id));
create policy "Bilet023 managers remove memberships" on public.bilet023_members for delete to authenticated using(public.bilet023_can_manage(tournament_id));

drop policy if exists "Bilet023 audit readers" on public.bilet023_audit_log;
create policy "Bilet023 audit readers" on public.bilet023_audit_log for select to authenticated using(public.bilet023_can_audit(tournament_id));

grant select on public.bilet023_tournaments,public.bilet023_teams to anon,authenticated;
grant insert,update,delete on public.bilet023_tournaments,public.bilet023_teams to authenticated;
grant select,insert,update,delete on public.bilet023_members to authenticated;
grant select on public.bilet023_audit_log to authenticated;
revoke insert,update,delete on public.bilet023_audit_log from anon,authenticated;

comment on table public.bilet023_members is 'Bilet 023 role map: admin, operator, auditor, viewer.';
comment on table public.bilet023_audit_log is 'Append-only server audit log; normal clients have read-only access by RLS.';
