# Davlat buyurtmachisiga topshirishdan oldingi tayyorgarlik reyestri

## Tayyor bo‘lgan texnik dalillar

- Bilet 023’ning 4 jamoa va 3/1/0 ochko qoidasi.
- 21 ko‘rsatkichli, 100 ballik ekspert baholash varaqasi.
- 14 ta avtomatik mantiqiy test.
- Vite production build.
- PostgreSQL sxemasining PGlite muhitida muvaffaqiyatli qo‘llanishi.
- RLS, owner/admin/operator/auditor/viewer ruxsatlari.
- Atomik save RPC va optimistic concurrency.
- Server audit triggerlari.
- Ommaviy view’da owner_id ustunini yashirish.
- README, arxitektura, maxfiylik va operatsion hujjatlar.

## Joriy to‘siqlar

| Yo‘nalish | Holat | Keyingi zarur harakat |
|---|---|---|
| Alohida Vercel loyiha | Ochiq | Vercel jamoasida Project Create ruxsatini berish va repo import qilish |
| Alohida Supabase loyiha | Ochiq | Buyurtmachi bilan tashkilot va xarajatni tasdiqlash; yangi loyiha ochish |
| Real DB migratsiyasi | Ochiq | Faqat alohida staging DB’da schema.sql qo‘llash |
| Browser UAT | Ochiq | Chrome, Firefox, Safari va Android/iOS qurilmalarida qo‘lda sinash |
| Penetration test | Ochiq | Mustaqil xavfsizlik tashkiloti xulosasi |
| Yuklama testi | Ochiq | Bir vaqtda foydalanuvchilar soni va SLA bo‘yicha sinov |
| Backup/DR | Ochiq | Backup siyosati, restore testi, RTO/RPO tasdiqlash |
| Accessibility | Qisman | WCAG 2.2 AA bo‘yicha audit |
| Huquqiy muvofiqlik | Ochiq | Ma’lumotlar klassifikatsiyasi, hosting va davlat reyestri masalalarini yuridik tekshirish |
| Buyurtmachi qabul testi | Ochiq | UAT protokoli va rasmiy qabul dalolatnomasi |

## Huquqiy va joylashuv nazorati

O‘RQ-1125-son Qonun 2026-yil 27-martdan kuchga kirgan. U ayrim ma’lumotlar toifalari, jumladan biometrik va genetik ma’lumotlar hamda telekommunikatsiya operatorlari xizmatidan foydalanuvchi jismoniy shaxslar ma’lumotlari uchun O‘zbekiston hududida saqlash talabini belgilaydi. Qonunning 20-moddasi bo‘yicha 27¹-moddaning ikkinchi qismida ko‘rsatilgan mahalliy saqlanishi shart bo‘lgan ma’lumotlar bazalari Davlat reyestrida ro‘yxatdan o‘tkazilishi kerak.

Rasmiy matnlar:
- https://lex.uz/uz/docs/-8099215
- https://www.lex.uz/uz/docs/-4396419

Loyiha oddiy turnir jadvali uchun biometrik/genetik yoki telekommunikatsiya abonent ma’lumotlarini yig‘maydi. Biroq Auth e-mail/identifikatorlari shaxsga doir ma’lumot bo‘lishi mumkin. Ma’lumotlar toifasi, operator/mulkdor va saqlash hududi buyurtmachi tomonidan tasdiqlanishi shart. Chet elda saqlashga oid qonuniy shartlar avtomatik bajarilgan deb hisoblanmaydi.

## Standartlar bo‘yicha maqsad

- OWASP ASVS 5.0.0 — web ilova xavfsizlik nazorati uchun tekshiruv ramkasi.
- WCAG 2.2 AA — raqamli foydalanish imkoniyati bo‘yicha maqsadli daraja.

Bu standartlarga muvofiqlik da’vo qilinmaydi; ular mustaqil tekshiruv uchun qabul mezoni sifatida taklif etiladi.

## Qaror

**Tavsiya etilgan maqom: nazorat ostidagi pilot uchun texnik nomzod.**

**Tavsiya etilmaydi:** hozircha davlatning ishlab turgan ma’lumotlar bazasi, fuqarolar shaxsiy ma’lumotlari yoki rasmiy musobaqa qarorlarini production rejimida yuritish. Yuqoridagi ochiq bandlar yopilib, buyurtmachi UAT va xavfsizlik tasdig‘ini bergandan keyingina production release ko‘rib chiqiladi.
