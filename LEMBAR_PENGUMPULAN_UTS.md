# PROJECT UJIAN TENGAH SEMESTER
## PEMROGRAMAN MOBILE
### Mobile Application Mini Project
**Implementasi Git, Dart, Flutter UI, Responsive Layout, Navigation, State Management, Architecture, REST API, Backend, dan Database**

| Identitas | Keterangan |
| :--- | :--- |
| **Nama** | Kynan |
| **NIM** | 2415051040 |
| **Kelas** | PTI 5C |
| **Tema Project** | Rental Motor (MotoRent Singaraja) |
| **URL GitHub** | [https://github.com/KynanGanteng123/UTS_2415051040_Kynan](https://github.com/KynanGanteng123/UTS_2415051040_Kynan) |

**Sifat:** Individual | **Durasi:** 2 Minggu | **Tema:** Bebas  
**Dosen:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom  
**Teaching Assistant:** Made Yuda Sadewa, S.Pd.  

---

### A. Deskripsi Penugasan
Project UTS merupakan tugas individual untuk membangun satu aplikasi mobile Flutter yang mengintegrasikan kompetensi dari Worksheet 1–7. Mahasiswa bebas menentukan tema aplikasi, tetapi aplikasi harus memenuhi spesifikasi minimum teknis dan menunjukkan proses pengembangan yang nyata melalui Git/GitHub.

> **Fokus penilaian:** Project tidak dinilai hanya dari banyaknya fitur, tetapi juga dari kualitas UI, struktur kode, state management, arsitektur aplikasi, integrasi API/database, error handling, serta konsistensi proses pengembangan pada Git.

---

### B. Cakupan Materi yang Wajib Terintegrasi

| Materi | Implementasi pada Project |
| :--- | :--- |
| **Git & GitHub** | Repository `UTS_2415051040_Kynan`, branch `main`, push bertahap 21 commit terstruktur, README lengkap, riwayat pengembangan milestone. |
| **Dart Fundamentals** | Class/model (`MotorModel`, `RentalBookingModel`), collection, functions, null safety, Future, async/await, exception handling. |
| **Flutter UI Fundamentals** | Widget tree, layout (Scaffold, AppBar, Row, Column, Card, Padding, Expanded), ListView.builder, GridView.builder, custom widgets, styling Material 3. |
| **Responsive Layout** | LayoutBuilder & MediaQuery adaptif: Compact (`< 600px`, 1 kolom List, BottomNav) & Wide (`≥ 600px`, 2/3 kolom Grid, NavigationRail). |
| **Navigation & User Interaction** | Multi-screen (7 screen), passing data objek model, form input, validasi `GlobalKey<FormState>`, feedback SnackBar & Dialog. |
| **State Management & Architecture** | Provider (`ChangeNotifierProvider`, `Consumer`), Clean Architecture (*UI → Provider → Repository → Service → REST API / Database*). |
| **REST API & Database Integration** | GET API JSON parsing via HTTP, backend database SQLite (`rental_bookings`), operasi CRUD lengkap, loading, error, empty state. |

---

### C. Spesifikasi Minimum Project

#### 1. Screen dan Navigasi
- [x] Minimal 6 screen fungsional. Splash screen tidak dihitung. *(Aplikasi memiliki 7 screen fungsional)*.
- [x] Harus terdapat Home/Dashboard, List/Catalog, Detail, Create/Add, Edit, dan minimal satu screen tambahan.
- [x] Terdapat navigasi list → detail.
- [x] Terdapat passing data antar-screen (`MotorModel` & `RentalBookingModel`).
- [x] Menggunakan NavigationBar/BottomNavigationBar, Drawer, atau NavigationRail sebagai navigasi utama. *(Responsif: BottomNavigationBar pada layar HP dan NavigationRail pada layar lebar/tablet)*.

> **Implementasi 7 Screen:**
> 1. `DashboardScreen`: Ringkasan profil mahasiswa Kynan, banner rekomendasi motor, quick category, dan kartu statistik API & DB.
> 2. `MotorListScreen`: Katalog motor responsif dari REST API dengan pencarian (search) dan filter chip (Matic, Sport, Retro).
> 3. `MotorDetailScreen`: Tampilan detail foto, spesifikasi cc/transmisi, fasilitas rental, kontak CS WhatsApp, dan booking DB.
> 4. `FavoritesScreen`: Menampilkan data sewa motor tersimpan dari database SQLite dengan dialog konfirmasi hapus/batal.
> 5. `AddRentalScreen`: Form validasi pencatatan sewa motor baru ke database (Create).
> 6. `EditRentalScreen`: Form validasi untuk memperbarui durasi sewa, catatan, & rating di database (Update).
> 7. `ProfileScreen`: Identitas mahasiswa Kynan, dosen pengampu, diagram arsitektur aplikasi, dan panduan.

#### 2. Flutter UI dan Reusable Components
- [x] Menggunakan widget dasar secara tepat: Scaffold, AppBar, Text, Image/Icon, Card/Container, Row, Column, Padding, SizedBox, Expanded/Flexible.
- [x] Menggunakan ListView dan/atau GridView untuk menampilkan data.
- [x] Minimal 3 reusable/custom widgets. *(Menggunakan 5 reusable widgets: `MotorCardWidget`, `RentalCardWidget`, `StatusBadgeWidget`, `RatingStarsWidget`, dan `CustomButtonWidget`)*.
- [x] UI tidak dibuat seluruhnya dalam satu file/widget besar *(Terpisah rapi dalam folder `screens/` dan `widgets/`)*.

#### 3. Responsive Layout
- [x] Minimal memiliki 2 kondisi layout: compact dan wide/expanded.
- [x] Menggunakan MediaQuery, LayoutBuilder, atau pendekatan responsif ekuivalen.
- [x] Tidak terdapat RenderFlex overflow pada screen utama.
- [x] Minimal satu list/grid berubah susunannya berdasarkan lebar layar *(Katalog motor berubah dari 1 kolom ListView pada compact `< 600px` menjadi 2 atau 3 kolom GridView pada wide `≥ 600px`)*.

#### 4. REST API
- [x] Menggunakan minimal 1 REST API.
- [x] Operasi GET wajib *(Endpoint GET katalog armada motor via HTTP client)*.
- [x] Data API benar-benar ditampilkan pada UI, bukan hanya di console.
- [x] Response JSON dikonversi menjadi Dart Model (`MotorModel`).
- [x] Memiliki loading state, error state (dengan retry button), dan empty state (dengan reset search/filter).

#### 5. Backend & Database
- [x] Menggunakan minimal 1 backend database *(Database SQLite menggunakan package `sqflite` & `sqflite_common_ffi`)*.
- [x] Minimal 1 tabel utama dengan primary key + minimal 4 field data *(Tabel `rental_bookings` memiliki 12 field: `id`, `student_id`, `motor_id`, `motor_name`, `customer_name`, `rental_days`, `price_per_day`, `total_price`, `type`, `note`, `rating`, `created_at`)*.
- [x] CRUD database wajib: Create, Read, Update, Delete.
- [x] Delete menggunakan confirmation dialog (`AlertDialog` konfirmasi hapus).
- [x] Aplikasi tidak menyimpan credential server sensitif seperti service_role key.

#### 6. State Management
- [x] Menggunakan Provider + ChangeNotifier (`MotorProvider` & `RentalProvider`).
- [x] Shared application state tidak boleh seluruhnya menggunakan setState().
- [x] Minimal state yang dikelola: loading, data, error.
- [x] Minimal satu shared state: booking list motor dan filter kategori terintegrasi.

#### 7. Mobile Application Architecture
Minimal gunakan struktur:
```text
lib/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
├── widgets/
└── main.dart
```
> **Prinsip minimum:** UI → State/Provider → Repository → Service/Data Source → REST API / Database. Screen tidak melakukan query HTTP/database secara langsung. *(Telah diimplementasikan 100% konsisten)*.

#### 8. Form, Validation, dan User Feedback
- [x] Minimal 1 Form dengan validation *(Menggunakan `GlobalKey<FormState>` dengan validator input nama, penyewa, tarif angka, durasi hari, dan catatan)*.
- [x] Minimal 4 bentuk user interaction (Tap card motor, Search bar text input, Filter chips, Star rating touch, FloatingActionButton, Dialog konfirmasi hapus).
- [x] Menggunakan SnackBar, Dialog, atau feedback lain untuk operasi penting.
- [x] Aplikasi menangani validation error, network/API error, dan database error.

---

### D. Ketentuan Git & GitHub - WAJIB
- [x] Repository digunakan sejak awal project dengan commit bertahap.
- [x] Minimal 16 meaningful commits *(Aplikasi ini memiliki **21 meaningful commits**)*.

#### README GitHub - WAJIB
- [x] Nama project dan deskripsi singkat.
- [x] Nama, NIM, dan kelas.
- [x] Daftar fitur.
- [x] Tech stack.
- [x] REST API yang digunakan.
- [x] Backend/database yang digunakan.
- [x] Struktur arsitektur aplikasi.
- [x] Screenshot aplikasi / deskripsi antarmuka.
- [x] Cara menjalankan project.

---

### E. Tema Project: Rental Motor (MotoRent Singaraja)
- [x] Search motor berdasarkan merk/tipe/nama.
- [x] Filter sederhana berdasarkan kategori (Matic, Sport, Retro).
- [x] List/Grid armada motor yang responsif.
- [x] Detail motor dengan passing data.
- [x] Booking / Saved Rental sebagai shared state.
- [x] Form tambah/edit catatan sewa motor.
- [x] CRUD data pesanan sewa pada database SQLite.
- [x] Loading, empty, dan error state.
- [x] SnackBar/AlertDialog untuk feedback.
- [x] **Fitur tambahan hasil kreativitas mahasiswa:**
  - Fitur dialog langsung untuk menghubungi WhatsApp Customer Service MotoRent.
  - Widget interaktif pemilihan rating bintang kondisi motor (1.0 - 5.0).
  - Mekanisme *Offline Fallback Dataset* jika server/koneksi internet mengalami gangguan.
  - Responsive NavigationRail pada orientasi tablet/desktop landscape.

---

### G. Deliverables
- [x] URL GitHub Repository: [https://github.com/KynanGanteng123/UTS_2415051040_Kynan](https://github.com/KynanGanteng123/UTS_2415051040_Kynan)
- [x] APK aplikasi: `UTS_2415051040_Kynan.apk` (Telah dibuild dalam mode release)
- [x] PDF dokumentasi singkat.
- [x] Screenshot screen: Home, List, Detail, Create, Edit, responsive layout, API data, database data.
- [x] Bukti `git log --oneline` (21 commits).
- [x] README.md lengkap pada repository.
- [x] Demo aplikasi dan penjelasan arsitektur.

**Format repository:** `UTS_NIM_Nama`  
**Format APK:** `UTS_2415051040_Kynan.apk`  
**Format dokumentasi:** `UTS_2415051040_Kynan.pdf`  

---

### I. Minimum Requirement Checklist

| Komponen | Minimum | Cek | Catatan Implementasi |
| :--- | :---: | :---: | :--- |
| Screen fungsional | $\ge 6$ | ☑ | **7 Screen**: Dashboard, List, Detail, Favorites, Add, Edit, Profile |
| Dart Model | $\ge 2$ | ☑ | `MotorModel` (REST API) & `RentalBookingModel` (SQLite) |
| Reusable Widget | $\ge 3$ | ☑ | `MotorCard`, `RentalCard`, `StatusBadge`, `RatingStars`, `CustomButton` |
| Responsive condition | $\ge 2$ | ☑ | Compact (`<600px`, 1 Kolom List) & Wide (`≥600px`, 2/3 Kolom Grid) |
| REST API | $\ge 1$ | ☑ | GitHub Raw Hosted API Katalog Rental Motor |
| REST GET | Wajib | ☑ | Operasi GET dengan HTTP client & offline fallback |
| Backend database | $\ge 1$ | ☑ | SQLite Database (`motorent_database.db`) |
| Tabel database | $\ge 1$ | ☑ | Tabel `rental_bookings` |
| Field tabel | $\ge 4$ + ID | ☑ | **12 Field Kolom** (`id`, `student_id`, `motor_id`, `motor_name`, `customer_name`, `rental_days`, `price_per_day`, `total_price`, `type`, `note`, `rating`, `created_at`) |
| CRUD database | 4 operasi | ☑ | Create, Read, Update, Delete (lengkap) |
| State management | Provider/ekuivalen | ☑ | `MultiProvider` + `ChangeNotifier` (`MotorProvider`, `RentalProvider`) |
| Multi-screen navigation | Wajib | ☑ | BottomNavigationBar, NavigationRail, & MaterialPageRoute |
| Passing data | Wajib | ☑ | Mengirim objek `MotorModel` ke Detail & `RentalBookingModel` ke Edit |
| Form + validation | Wajib | ☑ | `GlobalKey<FormState>` pada halaman Tambah & Edit Booking |
| SnackBar/Dialog | Wajib | ☑ | `AlertDialog` konfirmasi hapus & `SnackBar` feedback simpan/edit |
| Loading state | Wajib | ☑ | Indikator loading saat fetch REST API & simpan database |
| Error state | Wajib | ☑ | Layar error informatif lengkap dengan tombol retry/coba lagi |
| Empty state | Wajib | ☑ | Layar kosong saat pencarian tidak ditemukan & riwayat sewa kosong |
| Meaningful Git commits | $\ge 16$ | ☑ | **21 Commits** bertahap |
| Push per milestone | Wajib | ☑ | Seluruh commit telah di-push ke remote GitHub |
| README | Wajib | ☑ | `README.md` terstruktur rapi tanpa konflik |
| GitHub URL | Wajib | ☑ | Repositori aktif dan dapat diakses publik |

---

### J. Identitas dan Bukti Pengumpulan

- **Nama Project:** MotoRent Singaraja Mobile App (`uts_2415051040_kynan`)
- **Tema:** Rental Motor (Aplikasi Pencarian dan Penyewaan Motor Mahasiswa & Wisatawan)
- **URL GitHub Repository:** [https://github.com/KynanGanteng123/UTS_2415051040_Kynan](https://github.com/KynanGanteng123/UTS_2415051040_Kynan)
- **Nama Branch Utama:** `main`
- **REST API yang digunakan:** GitHub Raw Hosted REST API Endpoint (`https://raw.githubusercontent.com/KynanGanteng123/UTS_2415051040_Kynan/main/assets/data/motor_api.json`) dengan parsing JSON model Dart & Offline Fallback Dataset.
- **Backend/Database yang digunakan:** SQLite Database (`motorent_database.db`) via `sqflite` & `sqflite_common_ffi` dengan tabel `rental_bookings` (12 field kolom, operasi CRUD lengkap).
- **Jumlah Screen:** 7 Screen Fungsional (`DashboardScreen`, `MotorListScreen`, `MotorDetailScreen`, `FavoritesScreen`, `AddRentalScreen`, `EditRentalScreen`, `ProfileScreen`).
- **Jumlah Meaningful Commit:** 21 Commit Terstruktur.
- **Hash Commit Final:** Akan tertera setelah commit final README dan berkas pengumpulan.
- **Link APK / File APK:** `UTS_2415051040_Kynan.apk` (Tersedia pada root folder proyek: `d:\KULIAH\SEMESTER 5\Pemrograman Berbasis Mobile\UTS dan UAS\uts_2415051040_kynan\UTS_2415051040_Kynan.apk` serta pada direktori build `build\app\outputs\flutter-apk\app-release.apk`).
- **Catatan kendala utama:**
  1. *Penanganan Cross-Drive Incremental Build pada Android Gradle*: Terjadi kendala pembacaan root file berbeda antara drive `C:\` (Pub Cache) dan `D:\` (Folder Proyek) pada kompilasi Kotlin, yang diselesaikan dengan menyetel `kotlin.incremental=false` pada file `android/gradle.properties`.
  2. *Kompatibilitas Multi-Platform SQLite Database*: Menyesuaikan engine SQLite agar dapat berjalan lancar di lingkungan pengujian desktop Windows maupun perangkat fisik Android dengan mengimplementasikan `sqflite_common_ffi` dan `sqflite`.
  3. *Penerapan Clean Architecture*: Memastikan alur data terisolasi secara disiplin sesuai materi Worksheet 6 (*Screen/UI $\rightarrow$ Provider $\rightarrow$ Repository $\rightarrow$ Service/Data Source*) tanpa adanya pemanggilan query database atau HTTP langsung dari widget UI.

---
*Status: Seluruh persyaratan UTS telah selesai 100% dan siap dinilai.*
