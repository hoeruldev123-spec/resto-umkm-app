🚀 FLOW TIM YANG PALING AMAN
    Setiap mau coding:
    1️⃣ Update develop dulu
        git checkout (branch kalian)
        git pull origin develop

DAN SELALU BACA REAMI.MD
INTERUKSI UPDATE ADA DISITU

= = = = = = = = = = = = = = = = = = = = = =

🚨 RULE & PERINGATAN TIM PROJECT RESTOKU 🚨

1️⃣ DILARANG PUSH LANGSUNG KE `main`
Branch `main` hanya digunakan untuk versi final/presentasi.

Flow yang benar:
feature/* → develop → main

---

2️⃣ SETIAP ANGGOTA WAJIB CODING DI BRANCH MASING-MASING

✅ Anggota 1:
feature/core-testing

✅ Anggota 2:
feature/customer-menu

✅ Anggota 3:
feature/order-checkout

✅ Anggota 4:
feature/cashier-payment

---

3️⃣ JANGAN EDIT FILE `main.dart`
Kecuali Anggota 1 (Core & Testing)

Karena file ini rawan conflict dan bisa membuat aplikasi error.

---

4️⃣ WAJIB PULL TERLEBIH DAHULU SEBELUM CODING

Gunakan:
git checkout develop
git pull origin develop

Tujuannya agar project selalu update.

---

5️⃣ JANGAN PUSH JIKA PROJECT MASIH ERROR

Pastikan:
✅ Tidak ada error merah
✅ Flutter bisa run
✅ Tidak merusak fitur anggota lain

Test terlebih dahulu:
flutter run

---

6️⃣ GUNAKAN NAMA COMMIT YANG JELAS

Contoh:
✅ "Menambahkan halaman cart"
✅ "Membuat UI pembayaran QRIS"

Hindari:
❌ "update"
❌ "fix"
❌ "baru"

---

7️⃣ SETIAP FITUR HARUS MELALUI TESTING ANGGOTA 1

Sebelum merge ke develop:

* fitur akan dicek
* navigation akan dites
* flow aplikasi akan diuji

---

8️⃣ JANGAN MENGUBAH FOLDER ANGGOTA LAIN

Contoh:
❌ Anggota customer jangan edit folder cashier
❌ Anggota cashier jangan edit folder order

---

9️⃣ WAJIB KOMUNIKASI JIKA ADA PERUBAHAN BESAR

Jika ingin:

* ubah struktur folder
* ubah navigation
* rename file

WAJIB diskusi terlebih dahulu.

---

🔟 FLOW TESTING FINAL

Menu
→ Cart
→ Checkout
→ Kasir
→ Pembayaran
→ Receipt

Semua flow harus berjalan sebelum presentasi.

🔥 TARGET:
Project stabil, minim conflict, dan siap demo presentasi.
