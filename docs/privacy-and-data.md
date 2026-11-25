# Ma’lumotlar va maxfiylik bo‘yicha talablar

## Hozirgi ma’lumotlar oqimi
- Musobaqa nomi, hudud/tuman, sana, tavsif.
- Jamoa nomi, g‘alaba, durang, mag‘lubiyat.
- Kirgan foydalanuvchining Supabase Auth identifikatori va e-maili.
- Rol, audit hodisasi va vaqt belgisi.

Ilova biometrik, genetik, pasport, telefon raqami yoki telekommunikatsiya operatori abonent ma’lumotlarini talab qilmaydi. Real joriy etishda maydonlar to‘plami va ma’lumotlar sinfi buyurtmachi bilan tasdiqlanishi shart.

## O‘zbekiston qonunchiligi bo‘yicha tekshirish nuqtalari
O‘RQ-547-son “Shaxsga doir ma’lumotlar to‘g‘risida”gi Qonun 2026-yil 26-martdagi O‘RQ-1125 bilan o‘zgartirilgan. Qonunning amaldagi 27¹-moddasi ayrim shaxsga doir ma’lumotlar toifalari uchun O‘zbekiston hududida saqlash talablarini, boshqa ma’lumotlar uchun esa chet elda saqlash/ishlov berishning qonuniy shartlarini belgilaydi. 20-modda mahalliy saqlanishi shart bo‘lgan bazalarni Davlat reyestrida ro‘yxatdan o‘tkazish talabini belgilaydi.

Rasmiy manba: https://lex.uz/uz/acts/-4396419

## Majburiy production tekshiruvlari
1. Ma’lumotlar toifasini va operator/mulkdor rollarini yuridik maslahatchi bilan tasniflash.
2. Hosting region, zaxira nusxa hududi, loglar, e-mail provayderi va barcha subprocessorlarni ro‘yxatlash.
3. Transchegaraviy uzatish uchun qonundagi asoslardan biri amalda bajarilganini hujjatlashtirish.
4. Qaysi baza Davlat reyestriga kiritilishi lozimligini aniqlash va zarur bo‘lsa ro‘yxatdan o‘tkazish.
5. Saqlash muddati, yo‘q qilish, subyekt murojaatlari va hodisa haqida xabar berish tartibini tasdiqlash.
6. Ma’lumotlarni minimallashtirish: musobaqa jadvali uchun shaxsiy telefon, pasport yoki biometrik ma’lumotlarni yig‘maslik.

## Muhim cheklov
Hozirgi koddagi RLS, rollar va audit mexanizmi qonuniy muvofiqlikni o‘z-o‘zidan isbotlamaydi. Supabase project va Vercel joylashuvi alohida ko‘rib chiqilishi, buyurtmachi tasdiqlashi va shartnoma bilan mustahkamlanishi zarur.
