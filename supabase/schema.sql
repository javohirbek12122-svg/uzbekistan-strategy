-- Bilet 023: Turnir ochkolari jadvali
-- Idempotent schema for a dedicated namespace inside the Supabase project.
-- Points = wins * 3 + draws; losses award zero points.

create table if not exists public.bilet023_tournaments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Yangi turnir'
    check (char_length(btrim(title)) between 2 and 120),
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

create index if not exists bilet023_tournaments_owner_idx
  on public.bilet023_tournaments(owner_id, updated_at desc);
create index if not exists bilet023_teams_tournament_idx
  on public.bilet023_teams(tournament_id, sort_order);

alter table public.bilet023_tournaments enable row level security;
alter table public.bilet023_teams enable row level security;

drop policy if exists "Bilet023 owners can read tournaments" on public.bilet023_tournaments;
create policy "Bilet023 owners can read tournaments"
  on public.bilet023_tournaments for select to authenticated
  using (owner_id = (select auth.uid()));

drop policy if exists "Bilet023 owners can create tournaments" on public.bilet023_tournaments;
create policy "Bilet023 owners can create tournaments"
  on public.bilet023_tournaments for insert to authenticated
  with check (owner_id = (select auth.uid()));

drop policy if exists "Bilet023 owners can update tournaments" on public.bilet023_tournaments;
create policy "Bilet023 owners can update tournaments"
  on public.bilet023_tournaments for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

drop policy if exists "Bilet023 owners can delete tournaments" on public.bilet023_tournaments;
create policy "Bilet023 owners can delete tournaments"
  on public.bilet023_tournaments for delete to authenticated
  using (owner_id = (select auth.uid()));

drop policy if exists "Bilet023 owners can read teams" on public.bilet023_teams;
create policy "Bilet023 owners can read teams"
  on public.bilet023_teams for select to authenticated
  using (
    exists (
      select 1 from public.bilet023_tournaments t
      where t.id = tournament_id and t.owner_id = (select auth.uid())
    )
  );

drop policy if exists "Bilet023 owners can create teams" on public.bilet023_teams;
create policy "Bilet023 owners can create teams"
  on public.bilet023_teams for insert to authenticated
  with check (
    exists (
      select 1 from public.bilet023_tournaments t
      where t.id = tournament_id and t.owner_id = (select auth.uid())
    )
  );

drop policy if exists "Bilet023 owners can update teams" on public.bilet023_teams;
create policy "Bilet023 owners can update teams"
  on public.bilet023_teams for update to authenticated
  using (
    exists (
      select 1 from public.bilet023_tournaments t
      where t.id = tournament_id and t.owner_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1 from public.bilet023_tournaments t
      where t.id = tournament_id and t.owner_id = (select auth.uid())
    )
  );

drop policy if exists "Bilet023 owners can delete teams" on public.bilet023_teams;
create policy "Bilet023 owners can delete teams"
  on public.bilet023_teams for delete to authenticated
  using (
    exists (
      select 1 from public.bilet023_tournaments t
      where t.id = tournament_id and t.owner_id = (select auth.uid())
    )
  );

grant select, insert, update, delete on public.bilet023_tournaments to authenticated;
grant select, insert, update, delete on public.bilet023_teams to authenticated;

comment on table public.bilet023_tournaments is 'Bilet 023 turnir ochkolari jadvali: foydalanuvchi turnirlari.';
comment on table public.bilet023_teams is 'Bilet 023: jamoalar natijalari; ochko = g‘alaba × 3 + durang.';
