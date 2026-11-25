# Bilet 023 — tizim arxitekturasi va xavfsizlik chegaralari

## Maqsad
Bilet 023 bo‘yicha 4 jamoali musobaqa jadvalini yuritish, ochkolarni hisoblash, rasmiy holatni boshqarish, ommaviy natijani ko‘rsatish va o‘zgarishlar tarixini qayd etish.

Bu platforma umumiy davlat portali yoki davlat reyestri emas. U sport/ta’lim muassasasida sinab ko‘rish uchun mo‘ljallangan pilot modul.

## Komponentlar

| Qatlam | Texnologiya | Vazifasi |
|---|---|---|
| Foydalanuvchi interfeysi | Vite + HTML/CSS/JS | Jadval, musobaqa pasporti, ekspert baholashi |
| Statik hosting | Vercel | HTTPS va statik front-end tarqatish |
| Identifikatsiya | Supabase Auth | E-mail/parol asosida foydalanuvchi sessiyasi |
| Ma’lumotlar bazasi | PostgreSQL / Supabase | Turnir, jamoa, rol va audit ma’lumotlari |
| Ruxsatlar | PostgreSQL RLS | Turnir doirasida egaga/rolga asoslangan kirish |
| Hisoblash | src/scoring.mjs | 3/1/0 ochko va teng o‘rin algoritmi |
| Atomik saqlash | bilet023_save_tournament RPC | Musobaqa va 4 jamoani bitta tranzaksiyada yozish |
| Audit | PostgreSQL triggerlari | INSERT/UPDATE/DELETE hodisalarini serverda qayd qilish |

## Ma’lumotlar oqimi

1. Foydalanuvchi HTTPS orqali statik ilovani ochadi.
2. Auth sessiyasi bo‘lsa, foydalanuvchi identifikatori aniqlanadi.
3. Postgres RLS siyosatlari har bir turnir va rol uchun o‘qish/yozish ruxsatini tekshiradi.
4. Jadval o‘zgarishlari bilet023_save_tournament RPC orqali yuboriladi.
5. RPC turnir revision raqamini, jamoalarning revision raqamlarini va ruxsatlarni tekshiradi.
6. Bitta tranzaksiyada turnir va jamoalar saqlanadi; audit triggerlari oldingi/keyingi holatni jurnalga yozadi.
7. Faqat published holatidagi turnirlar ommaviy view orqali ko‘rsatiladi.

## Ruxsat modeli

| Rol | Jadvalni ko‘rish | Natijani tahrirlash | E’lon qilish | Audit |
|---|---|---|---|---|
| Owner | O‘z turniri | Ha | Ha | Ha |
| Admin | Biriktirilgan turnir | Ha | Ha | Ha |
| Operator | Biriktirilgan draft turnir | Faqat e’lon qilinmaguncha | Yo‘q | Yo‘q |
| Auditor | Biriktirilgan turnir | Yo‘q | Yo‘q | Ha |
| Viewer | Biriktirilgan yoki e’lon qilingan turnir | Yo‘q | Yo‘q | Yo‘q |
| Anonim | Faqat e’lon qilingan turnir | Yo‘q | Yo‘q | Yo‘q |

Rollar ma’lumotlar bazasida tekshiriladi. Front-enddagi yashirish yoki disabled holat yagona xavfsizlik chegarasi emas.

## Ma’lumotlar tasnifi

- **Ochiq:** e’lon qilingan musobaqa nomi, hudud, sana, jamoa nomlari va natijalar.
- **Ichki:** draft natijalar, turnirning ichki identifikatori, audit yozuvlari.
- **Shaxsga doir:** Auth foydalanuvchi UUID/e-maili, rol biriktirish va auditdagi actor identifikatori.
- **Yig‘ilmaydi:** biometrik, genetik, pasport va telefon ma’lumotlari.

Ochiq view owner_id va ichki audit ma’lumotlarini chiqarmaydi. anon roliga turnir jadvalining faqat ommaviy maydonlari uchun ustun darajasidagi ruxsat berilgan.

## Ma’lumotlar yaxlitligi

- Ochko: wins * 3 + draws.
- O‘yin: wins + draws + losses.
- Bazadagi points va played — generated columns.
- To‘rtta jamoa, takrorlanmaydigan nomlar va 0–999 butun sonli natijalar talab qilinadi.
- Revision tekshiruvi eskirgan foydalanuvchi yozuvini rad etadi.
- RPC xatolansa, tranzaksiya to‘liq rollback bo‘ladi.

## Ishonch chegaralari

- Brauzer foydalanuvchi qurilmasi ishonchsiz deb qaraladi.
- Publishable Supabase key maxfiy kalit emas; barcha ruxsat RLS bilan cheklanadi.
- Service-role key brauzerga kiritilmaydi.
- Audit logga odatiy klientlardan INSERT/UPDATE/DELETE berilmaydi.
- Ommaviy link maxfiy autentifikatsiya vositasi emas; faqat e’lon qilingan ma’lumotni ko‘rsatadi.

## Hozircha mavjud bo‘lmagan integratsiyalar
My.gov.uz, E-IMZO, OneID, davlat idoralarining ichki tarmoqlari yoki boshqa davlat API’lari bilan integratsiya yo‘q. Bunday ulanishlar buyurtmachining texnik shartlari, rasmiy API, identifikatsiya va axborot xavfsizligi roziligisiz qo‘shilmasligi kerak.
