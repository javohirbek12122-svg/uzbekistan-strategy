# Bilet 023 — Turnir ochkolari jadvali

Responsive Uzbek-language tournament standings app for the practical task in Bilet 023.

## Task rules
- Four teams.
- Win = 3 points, draw = 1 point, loss = 0 points.
- Total points are calculated automatically.
- Standings are sorted by points, descending.
- Teams with equal points receive the same rank.
- Required check: 2 wins + 1 draw = 7 points.

## Features
- Editable team names and win/draw/loss counters.
- Automatic played-match and points calculation.
- Equal-points ranking (competition ranking: 1, 1, 3).
- Local autosave for guest mode.
- Supabase email/password authentication and owner-scoped cloud storage.
- CSV export, print/PDF, dark mode and responsive mobile layout.
- Built-in logic checks for the requirements.

## Stack
- Semantic HTML, CSS and vanilla JavaScript.
- Supabase JS SDK 2.119.2 (pinned CDN import).
- Supabase Postgres tables use generated columns for `played` and `points`.
- GitHub source and Vercel static hosting.

## Database
The migration is in `supabase/schema.sql`. It was applied to the connected Supabase project under the dedicated tables `bilet023_tournaments` and `bilet023_teams`.
RLS is enabled and authenticated users can access only their own tournament data.

The browser publishable key is intended for client-side use; no service-role or secret key is included in this repository.

## Run
Open `index.html` through a static web server. Vercel can serve this as a static project without a build step.

Guest mode works locally. Use **Bulutga ulanish** to create an account or sign in before syncing data across devices.
