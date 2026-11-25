# Ekspluatatsiya va operatsion tayyorgarlik

## Muhitlar
- Development — ishlab chiquvchi testlari.
- Preview — buyurtmachi va ekspert ko‘rigi.
- Production — faqat alohida tasdiqlangan Vercel loyiha va Supabase baza.

## Release gate
1. Pull request tekshiruvi.
2. `npm ci`, `npm test`, `npm run build`.
3. Staging/preview smoke test.
4. DB migration review va RLS policy review.
5. Buyurtmachi UAT imzosi.
6. Tasdiqlangan release va rollback rejasi.

## Zaxira nusxa va tiklash
- Supabase backup siyosati va retention muddati buyurtmachi tomonidan tasdiqlansin.
- Har chorakda kamida bir marta tiklash sinovi bajarilsin.
- RPO/RTO talablarini tashkilot belgilasin; hozir bu tizimda rasmiy RPO/RTO kafolati yo‘q.

## Monitoring
- Vercel deployment/HTTP xatolari.
- Supabase Postgres/Auth xatolari va RLS rad javoblari.
- Audit log yozilishidagi uzilishlar.
- Ehtimoliy ma’lumot sizishi va noto‘g‘ri rollar.
- Monitoring uchun mas’ul shaxs va eskalatsiya zanjiri tayinlansin.

## Incident response
- Hodisani qayd etish.
- Ta’sirlangan muhit va ma’lumotlarni aniqlash.
- Kirish tokenlarini bekor qilish/rotatsiya.
- Dalillarni saqlash.
- Buyurtmachi, DPO va vakolatli organlarga tegishli tartibda xabar berish.
- Tuzatish, tiklash va post-incident review.
