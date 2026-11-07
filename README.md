# MotoRent - Aplikasi Rental Motor Singaraja

> **Project Ujian Tengah Semester (UTS) - Pemrograman Berbasis Mobile**  
> Program Studi Pendidikan Teknik Informatika (PTI)  
> Jurusan Teknik Informatika — Fakultas Teknik dan Kejuruan  
> Universitas Pendidikan Ganesha (Undiksha)

---

## 👤 Identitas Pengembang

| Data Mahasiswa | Keterangan |
| :--- | :--- |
| **Nama** | Kynan |
| **NIM** | 2415051040 |
| **Kelas** | PTI 5C |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Repositori GitHub** | [https://github.com/KynanGanteng123/UTS_2415051040_Kynan](https://github.com/KynanGanteng123/UTS_2415051040_Kynan) |

---

## 🛵 Deskripsi Project

**MotoRent** adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk mempermudah mahasiswa dan wisatawan dalam mencari, menyewa, serta mengelola katalog armada motor dan transaksi sewa motor di Singaraja dan Buleleng, Bali.

Aplikasi ini mengintegrasikan seluruh kompetensi dari Worksheet 1 hingga 7:
1. **Git & GitHub Workflow**: Pengembangan bertahap dengan >20 meaningful commits dan milestone terstruktur.
2. **Dart Fundamentals**: Model data berstruktur, null safety, collections, async/await, error & exception handling.
3. **Flutter UI & Reusable Components**: Widget modular, styling modern Material 3, clean widget tree.
4. **Responsive Layout**: Adaptif terhadap 2 kondisi layar (Compact `< 600px` dan Wide `≥ 600px`) menggunakan `LayoutBuilder` dan `NavigationRail`.
5. **Navigation & Passing Data**: Multi-screen navigation (9 screen fungsional), passing data model objek antar layar.
6. **State Management & Clean Architecture**: Implementasi `Provider` + `ChangeNotifier` dengan arsitektur berjenjang (*UI → Provider → Repository → Service → REST API / Database*).
7. **REST API Integration**: Pengambilan data katalog motor via HTTP GET dengan JSON parsing, loading state, error state, dan offline fallback dataset.
8. **Backend & Database CRUD**: Integrasi database SQLite (`motorent_database.db`) dengan **2 tabel utama** (`motors` dan `rental_bookings`) dengan operasi CRUD lengkap (*Create, Read, Update, Delete*) serta dialog konfirmasi hapus.

---

## 🚀 Fitur Utama Aplikasi

- [x] **Home / Dashboard**: Banner selamat datang dengan info profil mahasiswa Kynan, kartu statistik ringkasan data API dan Database SQLite, tombol cepat tambah unit motor, filter cepat kategori motor (Matic, Sport, Retro), serta daftar rekomendasi motor terpopuler.
- [x] **Katalog Motor Responsif (REST API & SQLite)**:
  - Tampilan otomatis berubah: **1 Kolom List** pada smartphone (Compact) dan **2/3 Kolom Grid** pada tablet/desktop (Wide).
  - Search bar interaktif pencarian merk, transmisi, cc, dan fasilitas.
  - Filter chip kategori: *Semua*, *Matic*, *Sport*, *Retro*, *Bebek*, dan *Touring*.
  - FloatingActionButton dan icon action bar untuk **Tambah Motor Baru**.
  - Menangani 4 kondisi UI: *Loading state*, *Error state* (dengan tombol retry), *Empty state* (dengan tombol reset filter & tambah motor), dan *Data state*.
- [x] **Manajemen Armada Motor (Database SQLite CRUD Unit Motor)**:
  - **Create**: Formulir `AddMotorScreen` untuk menambahkan unit motor baru ke katalog SQLite (nama motor, merk, tipe, kapasitas cc, tarif per hari, transmisi, URL gambar, rating, switch ketersediaan, fasilitas, dan deskripsi).
  - **Read**: Menampilkan seluruh data motor dari database SQLite dengan sinkronisasi awal dari REST API publik (GET).
  - **Update**: Formulir `EditMotorScreen` dengan tombol edit pada kartu motor dan detail motor untuk mengedit kolom spesifikasi motor.
  - **Delete**: Hapus unit motor dengan dialog konfirmasi `AlertDialog` ("Batal" / "Ya, Hapus").
- [x] **Detail Motor Lengkap**:
  - Banner foto motor dengan status ketersediaan (*Unit Tersedia* / *Disewa*).
  - Tombol aksi cepat: Edit Motor, Hapus Motor, dan Simpan Booking.
  - Informasi tarif sewa harian (`Rp xxx.xxx/hari`), rating bintang, dan spesifikasi (CC, Transmisi, Merk).
  - Daftar fasilitas sewa gratis (*Chips*: 2 Helm SNI, Jas Hujan, Phone Holder, dll).
  - Dialog interaksi langsung untuk menghubungi customer service via WhatsApp.
  - Form interaktif booking sewa langsung disimpan ke database SQLite.
- [x] **Manajemen Booking (Database SQLite CRUD Transaksi Sewa)**:
  - **Create**: Menambahkan pesanan rental motor atau catatan sewa mandiri (`AddRentalScreen`).
  - **Read**: Menampilkan daftar seluruh booking sewa motor aktif (`FavoritesScreen`).
  - **Update**: Mengedit durasi hari, penyewa, rating, dan catatan (`EditRentalScreen`).
  - **Delete**: Menghapus booking dari database dengan `AlertDialog` konfirmasi.
- [x] **Profil & Informasi UTS**: Rincian profil mahasiswa, info dosen pengampu, checklist spesifikasi UTS, dan diagram arsitektur aplikasi.
- [x] **User Feedback & Validation**:
  - `Form` dengan validasi `GlobalKey<FormState>` (validasi wajib diisi, format angka tarif, minimal 1 hari sewa, panjang minimal karakter).
  - Notifikasi visual menggunakan `SnackBar` untuk setiap operasi simpan, update, dan hapus.

---

## 🛠️ Tech Stack & Dependensi

| Kategori | Teknologi / Package | Fungsi |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.47.3 / Dart 3.13.3 | Framework cross-platform utama |
| **Design System** | Material Design 3 | Komponen UI, ColorScheme DeepOrange & Teal |
| **State Management** | `provider: ^6.1.1` | Pengelolaan state global (ChangeNotifier) |
| **HTTP / REST API** | `http: ^1.2.0` | Request HTTP GET dan pengambilan data JSON |
| **Database Lokal** | `sqflite: ^2.4.5` & `sqflite_common_ffi: ^2.4.5` | Engine database SQLite untuk Android dan Desktop |
| **Path Utility** | `path: ^1.9.1` | Manajemen lokasi direktori database |
| **Formatting** | `intl: ^0.20.3` | Format angka dan mata uang |
| **Icons** | `cupertino_icons: ^1.0.8` & Material Icons | Kumpulan icon antarmuka aplikasi |

---

## 🌐 Sumber Data & Integrasi

### 1. REST API (Katalog Motor)
- **Metode**: HTTP GET
- **Endpoint**: Hosted JSON pada repositori GitHub MotoRent
- **Model**: `MotorModel` (id, name, brand, type, cc, pricePerDay, transmission, imageUrl, rating, isAvailable, description, facilities)
- **Karakteristik**: Dilengkapi *Offline Fallback Dataset* via local assets `assets/data/motor_api.json` agar aplikasi tetap dapat berjalan lancar saat jaringan offline.

### 2. Database Backend SQLite (`motorent_database.db`)
Aplikasi memiliki **dua tabel database SQLite** terintegrasi:

#### A. Tabel `motors` (Katalog Armada Motor)
1. `id`: `INTEGER PRIMARY KEY AUTOINCREMENT`
2. `name`: `TEXT NOT NULL`
3. `brand`: `TEXT NOT NULL`
4. `type`: `TEXT NOT NULL`
5. `cc`: `INTEGER NOT NULL`
6. `price_per_day`: `INTEGER NOT NULL`
7. `transmission`: `TEXT NOT NULL`
8. `image_url`: `TEXT NOT NULL`
9. `rating`: `REAL NOT NULL`
10. `is_available`: `INTEGER NOT NULL`
11. `description`: `TEXT NOT NULL`
12. `facilities`: `TEXT NOT NULL`

#### B. Tabel `rental_bookings` (Transaksi Booking Sewa)
1. `id`: `INTEGER PRIMARY KEY AUTOINCREMENT`
2. `student_id`: `TEXT NOT NULL` (NIM: 2415051040)
3. `motor_id`: `INTEGER NOT NULL`
4. `motor_name`: `TEXT NOT NULL`
5. `customer_name`: `TEXT NOT NULL`
6. `rental_days`: `INTEGER NOT NULL`
7. `price_per_day`: `INTEGER NOT NULL`
8. `total_price`: `INTEGER NOT NULL`
9. `type`: `TEXT NOT NULL`
10. `note`: `TEXT NOT NULL`
11. `rating`: `REAL NOT NULL`
12. `created_at`: `TEXT NOT NULL`

---

## 🏛️ Arsitektur Aplikasi (Clean Architecture)

```text
lib/
├── models/
│   ├── motor_model.dart              # Dart class model motor & serialisasi JSON / Map
│   └── rental_booking_model.dart     # Dart class model transaksi rental booking SQLite
├── services/
│   ├── api_service.dart              # HTTP GET client REST API dengan offline fallback
│   └── database_service.dart         # SQLite Database Helper (tabel motors & rental_bookings)
├── repositories/
│   ├── motor_repository.dart         # Sinkronisasi data katalog motor API + SQLite
│   └── rental_repository.dart        # Abstraksi data pesanan sewa motor
├── providers/
│   ├── motor_provider.dart           # State Management katalog, filter kategori, search, CRUD motor
│   └── rental_provider.dart          # State Management booking sewa, penghitungan total, CRUD booking
├── widgets/
│   ├── motor_card_widget.dart        # Reusable card motor responsif dengan tombol edit & bookmark
│   ├── rental_card_widget.dart       # Reusable card pesanan sewa dengan badge & total biaya
│   ├── status_badge_widget.dart      # Reusable badge indikator kategori dan status ketersediaan
│   ├── rating_stars_widget.dart      # Reusable interactive & static star rating component
│   └── custom_button_widget.dart     # Reusable custom button dengan loading state
├── screens/
│   ├── home_screen.dart              # Root screen dengan adaptif NavigationBar / NavigationRail
│   ├── dashboard_screen.dart         # Layar dashboard utama, profil mahasiswa & statistik
│   ├── motor_list_screen.dart        # Layar katalog armada motor (responsif list/grid)
│   ├── motor_detail_screen.dart      # Layar rincian spesifikasi unit motor & form sewa
│   ├── add_motor_screen.dart         # Form validasi Create unit motor baru ke SQLite
│   ├── edit_motor_screen.dart        # Form validasi Update unit motor ke SQLite
│   ├── favorites_screen.dart         # Layar daftar booking rental tersimpan di SQLite
│   ├── add_rental_screen.dart        # Form validasi Create catatan sewa motor baru
│   ├── edit_rental_screen.dart       # Form validasi Update catatan sewa motor di SQLite
│   └── profile_screen.dart           # Layar profil pengembang mahasiswa, identitas & checklist UTS
└── main.dart                         # Entry point aplikasi dengan MultiProvider & Theme
```

---

## 📱 Sembilan Screen Fungsional

1. **`DashboardScreen`**: Ringkasan data armada dan booking, profil mahasiswa Kynan, dan rekomendasi populer.
2. **`MotorListScreen`**: Katalog motor dengan search, filter chip kategori, dan FloatingActionButton Tambah Motor.
3. **`MotorDetailScreen`**: Rincian unit motor, spesifikasi, tombol Edit Motor, tombol Hapus Motor, WhatsApp CS, dan booking bottom sheet.
4. **`AddMotorScreen`**: Form validasi tambah unit motor baru ke database SQLite.
5. **`EditMotorScreen`**: Form validasi edit data motor di database SQLite.
6. **`FavoritesScreen`**: Menampilkan daftar seluruh booking sewa motor dari SQLite.
7. **`AddRentalScreen`**: Form pencatatan sewa motor manual ke database.
8. **`EditRentalScreen`**: Form update data durasi, penyewa, rating, dan catatan sewa.
9. **`ProfileScreen`**: Informasi identitas mahasiswa, diagram arsitektur, dan checklist UTS.

---

## 🏃 Cara Menjalankan Project

1. **Clone repositori**:
   ```bash
   git clone https://github.com/KynanGanteng123/UTS_2415051040_Kynan.git
   cd UTS_2415051040_Kynan
   ```

2. **Ambil semua dependensi package**:
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian (Unit & Widget Test)**:
   ```bash
   flutter test
   ```

4. **Jalankan analisis kode**:
   ```bash
   flutter analyze
   ```

5. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

6. **Build APK Release**:
   ```bash
   flutter build apk --release
   ```
   *File APK release telah disiapkan langsung di root folder: `UTS_2415051040_Kynan.apk`.*

---
*Dikembangkan oleh Kynan (NIM: 2415051040) — PTI Undiksha 2026*
