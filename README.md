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

**MotoRent** adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk mempermudah mahasiswa dan wisatawan dalam mencari, menyewa, dan mengelola pemesanan sewa motor di seputaran Singaraja dan Buleleng, Bali.

Aplikasi ini mengintegrasikan seluruh kompetensi dari Worksheet 1 hingga 7:
1. **Git & GitHub Workflow**: Pengembangan bertahap dengan >16 meaningful commits dan milestone terstruktur.
2. **Dart Fundamentals**: Model data berstruktur, null safety, collections, async/await, error & exception handling.
3. **Flutter UI & Reusable Components**: Widget modular, styling modern Material 3, clean widget tree.
4. **Responsive Layout**: Adaptif terhadap 2 kondisi layar (Compact `< 600px` dan Wide `≥ 600px`) menggunakan `LayoutBuilder` dan `NavigationRail`.
5. **Navigation & Passing Data**: Multi-screen navigation (7 screen), passing data model objek antar layar.
6. **State Management & Clean Architecture**: Implementasi `Provider` + `ChangeNotifier` dengan arsitektur berjenjang (*UI → Provider → Repository → Service → REST API / Database*).
7. **REST API Integration**: Pengambilan data katalog motor via HTTP GET dengan JSON parsing, loading state, error state, dan offline fallback dataset.
8. **Backend & Database CRUD**: Integrasi database SQLite (`rental_bookings`) dengan operasi CRUD lengkap (*Create, Read, Update, Delete*) serta dialog konfirmasi hapus.

---

## 🚀 Fitur Utama Aplikasi

- [x] **Home / Dashboard**: Banner selamat datang dengan info profil mahasiswa Kynan, kartu statistik ringkasan data API dan Database, filter cepat kategori motor (Matic, Sport, Retro), serta daftar rekomendasi motor terpopuler.
- [x] **Katalog Motor Responsif (REST API)**:
  - Tampilan otomatis berubah: **1 Kolom List** pada smartphone (Compact) dan **2/3 Kolom Grid** pada tablet/desktop (Wide).
  - Search bar interaktif pencarian merk, transmisi, cc, dan fasilitas.
  - Filter chip kategori: *Semua*, *Matic*, *Sport*, dan *Retro*.
  - Menangani 4 kondisi UI: *Loading state*, *Error state* (dengan tombol retry), *Empty state* (dengan tombol reset filter), dan *Data state*.
- [x] **Detail Motor Lengkap**:
  - Banner foto motor dengan status ketersediaan (*Tersedia* / *Disewa*).
  - Informasi tarif sewa harian (`Rp xxx.xxx/hari`), rating bintang, dan spesifikasi (CC, Transmisi, Merk).
  - Daftar fasilitas sewa gratis (*Chips*: 2 Helm SNI, Jas Hujan, Phone Holder, Bensin Awal).
  - Dialog interaksi langsung untuk menghubungi customer service via WhatsApp.
  - Form interaktif booking sewa langsung disimpan ke database SQLite (lengkap dengan durasi hari, nama penyewa, rating, dan catatan).
- [x] **Manajemen Booking (Database SQLite CRUD)**:
  - **Create**: Menambahkan pesanan rental motor baru atau catatan sewa mandiri ke database.
  - **Read**: Menampilkan daftar seluruh booking tersimpan beserta durasi hari dan total biaya.
  - **Update**: Mengedit nama penyewa, durasi, rating bintang, dan catatan di database.
  - **Delete**: Membatalkan pesanan tersimpan dengan **AlertDialog konfirmasi** (*Batal* / *Hapus*).
- [x] **Profil & Informasi UTS**: Rincian profil mahasiswa, info dosen pengampu, checklist spesifikasi UTS, dan diagram arsitektur aplikasi.
- [x] **User Feedback & Validation**:
  - `Form` dengan validasi `GlobalKey<FormState>` (validasi wajib diisi, format angka tarif, minimal 1 hari sewa).
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

### 2. Database Backend (Rental Bookings)
- **Engine**: SQLite Database (`motorent_database.db`)
- **Tabel**: `rental_bookings`
- **Skema Kolom**:
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

## 🏗️ Struktur Arsitektur Aplikasi

Proyek ini menerapkan prinsip **Clean Architecture & Separation of Concerns**:

```
UI / Screens / Widgets
       ↓ (Consumer / Provider.of)
Providers (State Management - ChangeNotifier)
       ↓ (Dependency Injection)
Repositories (Data Abstraction Layer)
       ↓ (Service Invocation)
Services / Data Sources (REST API & SQLite Database)
```

### Struktur Direktori:

```text
lib/
├── models/
│   ├── motor_model.dart          # Dart model untuk data REST API katalog motor
│   └── rental_booking_model.dart # Dart model untuk tabel database SQLite
├── services/
│   ├── api_service.dart          # HTTP client & parsing JSON dengan offline fallback
│   └── database_service.dart     # SQLite Database helper (OpenDB, Create, Query, CRUD)
├── repositories/
│   ├── motor_repository.dart     # Abstraksi repositori katalog motor
│   └── rental_repository.dart    # Abstraksi repositori database rental
├── providers/
│   ├── motor_provider.dart       # State management katalog (search, filter, loading)
│   └── rental_provider.dart      # State management CRUD database rental
├── screens/
│   ├── home_screen.dart          # Navigation shell (BottomNavigationBar & NavigationRail)
│   ├── dashboard_screen.dart     # Dashboard statistik & rekomendasi
│   ├── motor_list_screen.dart    # Katalog motor responsif (list/grid)
│   ├── motor_detail_screen.dart  # Detail motor & interaksi booking
│   ├── favorites_screen.dart     # Riwayat sewa motor di DB (Read & Delete konfirmasi)
│   ├── add_rental_screen.dart    # Form validasi catat sewa baru (Create)
│   ├── edit_rental_screen.dart   # Form validasi perbarui sewa (Update)
│   └── profile_screen.dart       # Profil mahasiswa Kynan & info UTS
├── widgets/
│   ├── motor_card_widget.dart    # Reusable card katalog motor
│   ├── rental_card_widget.dart   # Reusable card pesanan rental
│   ├── status_badge_widget.dart  # Reusable badge status ketersediaan & tipe
│   ├── rating_stars_widget.dart  # Reusable rating bintang (display & interactive)
│   └── custom_button_widget.dart # Reusable button dengan loading state
└── main.dart                     # Entry point & MultiProvider registration
```

---

## 📐 Responsive Layout Implementation

Aplikasi secara dinamis beradaptasi berdasarkan lebar layar:
- **Compact Screen (`< 600px` - Smartphone)**:
  - Navigasi utama menggunakan `BottomNavigationBar` di bagian bawah layar.
  - Katalog motor dirender dalam bentuk `ListView.builder` (1 kolom vertikal).
- **Wide Screen (`≥ 600px` - Tablet / Layar Lebar / Landscape)**:
  - Navigasi utama berpindah ke sisi samping kiri menggunakan `NavigationRail`.
  - Katalog motor secara otomatis beralih menjadi `GridView.builder` (2 atau 3 kolom) dengan proporsi kartu yang pas dan terhindar dari RenderFlex overflow.

---

## 📋 Daftar Screen (7 Screen Fungsional)

1. **DashboardScreen**: Ringkasan armada motor, banner mahasiswa, statistik, kategori cepat.
2. **MotorListScreen**: Katalog motor responsif dengan search, filter kategori, dan 4 state (loading, error, empty, data).
3. **MotorDetailScreen**: Spesifikasi CC/transmisi, fasilitas sewa, foto, kontak WhatsApp CS, dan bottom sheet booking.
4. **FavoritesScreen**: Daftar pesanan rental tersimpan di SQLite dengan fitur cancel/delete konfirmasi dialog.
5. **AddRentalScreen**: Form validasi untuk membuat pesanan sewa baru ke database (Create).
6. **EditRentalScreen**: Form validasi untuk memperbarui durasi, rating, dan catatan sewa di database (Update).
7. **ProfileScreen**: Identitas mahasiswa Kynan, info dosen pengampu, ringkasan arsitektur, dan tautan repositori.

---

## 🚀 Cara Menjalankan Project

### Prasyarat
- Flutter SDK (≥ 3.13.0)
- Android Studio / VS Code dengan Flutter Extension
- Perangkat Android (Emulator atau HP Fisik dengan USB Debugging aktif)

### Langkah-langkah:
1. **Clone Repositori**:
   ```bash
   git clone https://github.com/KynanGanteng123/UTS_2415051040_Kynan.git
   cd UTS_2415051040_Kynan
   ```

2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Analisis Kode (Linter)**:
   ```bash
   flutter analyze
   ```

4. **Jalankan Pengujian Otomatis**:
   ```bash
   flutter test
   ```

5. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

6. **Build APK Release**:
   ```bash
   flutter build apk --release
   ```
   File APK hasil build akan berlokasi di:  
   `build/app/outputs/flutter-apk/app-release.apk`  
   (Dapat diganti nama menjadi `UTS_2415051040_Kynan.apk` untuk pengumpulan).

---

*Selamat menggunakan aplikasi MotoRent!*
