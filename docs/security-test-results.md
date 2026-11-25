# Texnik test natijalari

Sana: 2026-11-25

## Avtomatik mantiqiy testlar

Node.js test suite natijasi:
- Testlar: 14
- Muvaffaqiyatli: 14
- Xatolik: 0

Sinovlar ochko formulasi, mag‘lubiyatga nol ochko, o‘yinlar soni, reytingni saralash, teng o‘rinlar, barqaror tartib, noto‘g‘ri qiymatlar, 4 jamoa sharti va takroriy nomlarni tekshiradi.

## Production build

- Vite 7.2.2
- npm run build: muvaffaqiyatli
- 48 modul production bundle’ga o‘tkazilgan
- JavaScript va CSS alohida statik asset sifatida yig‘ilgan

## PostgreSQL sxema va xavfsizlik sinovi

Sxema alohida PGlite/PostgreSQL mos test muhiti ichida ishga tushirildi. Bu foydalanuvchining Supabase loyihasiga ulanish yoki migratsiyani ishlab turgan bazaga qo‘llash emas.

Sinov natijalari:
| Tekshiruv | Natija |
|---|---|
| To‘liq SQL sxemani qo‘llash | O‘tdi |
| 4 jamoa va generated points/played ustunlari | O‘tdi |
| Atomik save RPC | O‘tdi |
| Revision raqamlarining oshishi | O‘tdi |
| Eskirgan revision bilan yozishni rad etish | O‘tdi |
| Server audit hodisalari | 10 ta hodisa yozildi |
| E’lon qilingan turnirni anonim view orqali o‘qish | O‘tdi |
| Anonim foydalanuvchidan owner_id ustunini yashirish | O‘tdi |
| Viewer roliga o‘qish ruxsati | O‘tdi |
| Viewer rolidan yozishni rad etish | O‘tdi |

## Tekshirilmagan yoki tashqi muhit talab qiladigan tekshiruvlar

- Haqiqiy Supabase staging loyihasida Auth, RLS va e-mail tasdiqlash.
- Real brauzerlar va telefonlarda qo‘lda UAT.
- Chromium asosidagi UI avtomatlashtirish: sinov muhiti Chromium’ni ishga tushira olmadi; bu test bajarilmadi, muvaffaqiyatli deb hisoblanmaydi.
- Mustaqil penetration test.
- Yuklama, stress va uzoq muddatli chidamlilik sinovi.
- Backup restore va disaster-recovery mashqi.
- WCAG 2.2 AA bo‘yicha mustaqil accessibility audit.
- Real hosting hududi va shaxsga doir ma’lumotlar bo‘yicha yuridik xulosa.

## Talqin
Bu natijalar dasturiy mantiq va ma’lumotlar bazasi sxemasi uchun foydali sinov dalilidir. Ular ishlab turgan Supabase/Vercel konfiguratsiyasining sertifikati, mustaqil pentest yoki davlat xavfsizlik ruxsatnomasi hisoblanmaydi.
