# Bilet 023 — Turnir boshqaruv platformasi

Bilet 023 topshirig‘i asosida tayyorlangan, to‘rtta jamoa uchun turnir ochkolari jadvali. Loyiha Vite + vanilla JavaScript + Supabase Postgres/RLS arxitekturasida quriladi.

## Bilet 023 qoidalari
- Aynan 4 ta jamoa.
- G‘alaba = 3 ochko; durang = 1 ochko; mag‘lubiyat = 0 ochko.
- Ochko = (g‘alaba × 3) + durang.
- Jadval ochko kamayish tartibida saralanadi.
- Teng ochkoli jamoalar teng o‘rin oladi (1, 1, 3).
- Majburiy tekshiruv: 2 g‘alaba + 1 durang = 7 ochko.

## Funksiyalar
- Jamoa nomi va natijalarini tahrirlash.
- O‘yinlar soni va ochkolarni avtomatik hisoblash.
- Teng natijalarda teng o‘rin ko‘rsatish.
- Mahalliy saqlash, CSV eksport, chop etish/PDF.
- Ekspert baholash varaqasining 21 ta ko‘rsatkichi va 100 ballik hisoblagichi.
- Draft / published holatlari va ommaviy read-only jadval havolasi.
- Owner, admin, operator, auditor va viewer rollari uchun RLS modeli.
- Server tomonidan yoziladigan, oddiy mijoz o‘zgartira olmaydigan audit jurnali.
- Mobil interfeys, qorong‘i rejim, PWA shell.

## Arxitektura
- `src/main.js` — interfeys, autentifikatsiya va ma’lumotlar oqimi.
- `src/scoring.mjs` — sof hisoblash va validatsiya qoidalari.
- `src/scoring.test.mjs` — avtomatik mantiqiy testlar.
- `src/style.css` — interfeys uslubi.
- `supabase/schema.sql` — alohida Bilet 023 bazasi uchun RLS/audit sxemasi.
- `docs/` — operatsion, xavfsizlik va qabul qilish hujjatlari.

## Local development
1. Node.js 20 yoki undan yangi versiyani o‘rnating.
2. `npm install`
3. `npm test`
4. `npm run dev`

Cloud integration is intentionally disabled until a dedicated Supabase project is provisioned. Set these Vercel environment variables for production/preview:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`

Never use a Supabase service-role key in browser environment variables.

## Database deployment
Apply `supabase/schema.sql` only to a dedicated Bilet 023 Supabase project. Do not apply it to Yoshlar-Ishi, Parkent E-Market, or any unrelated production database.

## Vercel
The `vercel.json` file configures Vite build, static output and baseline response security headers. Connect this repository to a separate Vercel project named `bilet023-turnir-ochkolari`, then add the two public Supabase environment variables when the dedicated database exists.

## Public-sector readiness boundary
This repository is a technically structured pilot, not a certified state information system. Production adoption requires the operating authority to approve:
- legal basis, data controller/processor roles and privacy notice;
- hosting region and any cross-border data transfer;
- applicable database registration and data classification;
- identity provider and institutional account lifecycle;
- independent security testing, backup restore, DR/RTO/RPO and monitoring;
- procurement, SLA, support, incident response and accessibility acceptance.

Relevant engineering targets: OWASP ASVS 5.0 and WCAG 2.2 AA. No conformance or certification claim is made without independent verification.
