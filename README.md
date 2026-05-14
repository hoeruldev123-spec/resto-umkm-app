RESTOKU

Smart Restaurant Ordering App for UMKM

RESTOKU adalah aplikasi pemesanan restoran berbasis mobile yang dibuat menggunakan Flutter untuk membantu digitalisasi UMKM restoran dalam proses pemesanan, pembayaran, dan pengelolaan transaksi.

Project ini dibuat sebagai tugas besar perkuliahan dengan konsep:

Pengunjung dapat melakukan pemesanan makanan/minuman
Kasir dapat mengelola pesanan dan pembayaran

🚀 Features

    👤 Pengunjung
        Melihat daftar menu
        Detail menu makanan/minuman
        Menambahkan menu ke keranjang
        Checkout pesanan
        Melihat status pesanan

    💼 Kasir
        Dashboard kasir
        Melihat daftar pesanan
        Konfirmasi pesanan
        Pembayaran:
            Tunai
            QRIS
            EDC
        Cetak struk pembayaran

    Pembayaran masih menggunakan metode manual
    🧠 Penjelasan

        👉 Saat pengunjung klik Checkout, itu:
        ❌ BELUM bayar

        Tapi:
        ✅ Mengirim pesanan ke kasir/dapur

        Jadi pembayaran dilakukan:

        di kasir secara tunai / QRIS
        🔥 Ini paling cocok untuk:
            Warung
            Cafe
            Resto UMKM
            Tempat makan biasa

= = = = = = = = = = = = = = = =

#Project ini masoh tahap demo
    - Belum menggunakan database
    - Kasir dan Pengunjung masih di satu development
    - Jika sudah tahap produksi, akan disesuakn tech stack dengan kebutuhan real di UMKM tersebut.

= = = = = = = = = = = = = = = =

🛠️ Tech Stack
    Teknologi	            Keterangan
    -Flutter	            Frontend Mobile
    -Dart	                Bahasa Pemrograman
    -GitHub	                Version Control
    -Dummy Data	            Database (prototype)


📁 Project Structure
    lib/
    │
    ├── core/
    │   ├── routes/
    │   └── theme/
    │
    ├── screens/
    │   ├── splash/
    │   ├── role/
    │   ├── customer/
    │   ├── order/
    │   └── cashier/
    │
    ├── widgets/
    ├── data/
    ├── models/
    └── utils/

👥 Team Division

    Anggota	                Tugas
    -Anggota 1	            App Core, Navigation, Testing
    -Anggota 2	            Customer Menu & Cart
    -Anggota 3	            Checkout & Order Status
    -Anggota 4	            Cashier & Payment

    Rincian Tugas
    👨‍💻 ANGGOTA 1 — APP CORE + TESTING
        Fokus:
        Sebagai pusat integrasi project

        Tugas:
        ✅ Setup Flutter project
        ✅ Setup GitHub repository
        ✅ Struktur folder
        ✅ Navigation / routing
        ✅ Theme aplikasi
        ✅ Bottom navigation
        ✅ Reusable widget
        ✅ Merge branch anggota lain
        ✅ Testing semua fitur
        ✅ Fix conflict Git

        File yang dipegang:
            main.dart
            routes/
            theme/
            widgets/
            utils/

    👨‍💻 ANGGOTA 2 — MENU & CART
        Fokus:
        Flow eksplorasi makanan

        Tugas:
        ✅ Home customer
        ✅ List menu
        ✅ Detail menu
        ✅ Search menu
        ✅ Kategori makanan
        ✅ Tambah ke cart
        ✅ Quantity item

        Folder:
            screens/customer/

    👨‍💻 ANGGOTA 3 — CHECKOUT & STATUS
        Fokus:
        Alur pemesanan customer

        Tugas:
        ✅ Halaman checkout
        ✅ Input nama & meja
        ✅ Ringkasan pesanan
        ✅ Status order
        ✅ Nomor antrian
        ✅ Simulasi status:
            menunggu
            diproses
            selesai

        Folder:
            screens/order/


    👨‍💻 ANGGOTA 4 — KASIR & PEMBAYARAN
        Fokus:
        Flow kasir

        Tugas:
        ✅ Dashboard kasir
        ✅ List pesanan masuk
        ✅ Detail pesanan
        ✅ Pilihan pembayaran:
            Tunai
            QRIS
            EDC
        ✅ Cetak struk
        ✅ Simulasi pembayaran berhasil

        Folder:
            screens/cashier/

🌳 Git Branch Strategy
    main
    develop
    feature/core-testing
    feature/customer-menu
    feature/order-checkout
    feature/cashier-payment

🔥 Penjelasan Tiap Branch
    Branch	            Fungsi
    - feature/*	        Tempat coding masing-masing anggota
    - develop	        Tempat gabungan semua fitur
    - main	            Versi final/stabil untuk presentasi

🚨 RULE & PERINGATAN TIM PROJECT RESTOKU 🚨

    1️⃣ DILARANG PUSH LANGSUNG KE `main`
        Branch `main` hanya digunakan untuk versi final/presentasi.

        Flow yang benar:
        feature/* → develop → main

    ---

    2️⃣ SETIAP ANGGOTA WAJIB CODING DI BRANCH MASING-MASING

    ✅ Anggota 1:
    main
    develop
    feature/core-testing

    ✅ Anggota 2:
    feature/customer-menu

    ✅ Anggota 3:
    feature/order-checkout

    ✅ Anggota 4:
    feature/cashier-payment

    ⚠️ Dilarang coding langsung di branch main atau develop.
    Semua pengerjaan wajib dilakukan di branch masing-masing untuk menghindari conflict dan kehilangan progress project.

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


🔄 Git Workflow
    Clone Repository
        git clone URL_REPOSITORY

    Pindah ke Branch feature
        git checkout feature/nama-branch

    Commit Changes
        git add .
        git commit -m "Menambahkan fitur cart"

    Push Branch
        git push origin feature/nama-branch

📱 Main Application Flow
    👤 Customer
        View Menu
        → Add to Cart
        → Checkout
        → Order Status
        → Payment

    💼 Cashier
        Receive Order
        → Process Order
        → Payment
        → Print Receipt

    💳 Payment Methods
        Cash
        QRIS
        EDC

    🎯 Project Goals
        Membantu digitalisasi UMKM restoran
        Mempermudah proses pemesanan
        Membantu kasir mengelola transaksi
        Menjadi prototype aplikasi restoran modern

🧪 Testing

    Testing dilakukan pada:
        Navigation flow
        Cart functionality
        Checkout process
        Payment simulation
        Receipt generation

📌 Notes

    Project ini masih berupa prototype/demo:
        Menggunakan dummy data
        Belum menggunakan backend production
        Fokus pada UI/UX dan flow sistem

📷 Screenshots
(Add screenshots here)

📄 License

    Project ini dibuat untuk kebutuhan pembelajaran dan tugas perkuliahan.

❤️ Developed By

    Kelompok 1 Tugas Besar Pemrograman Mobile Lnajut — 
    Sistem Aplikasi Restoran UMKM
    
    1. Hoirul Umam 
    2. Angga Apriansyah 
    3. Tri Suherman 
    4. Andika Mega Sanjaya