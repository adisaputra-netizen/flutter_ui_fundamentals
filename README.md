# flutter_ui_fundamentals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Course Explorer v2 - Architecture & Separation of Concerns

Proyek ini menerapkan Clean Architecture dengan aliran dependensi satu arah:
**Screen / Widget -> Provider -> Repository -> Service / Data Source**

## Arsitektur & Dependency Direction
Screen/Widget -> Provider -> Repository -> Service/DataSource

Tanggung jawab folder:
- `models/`: Definisi struktur data aplikasi.
- `services/`: Komunikasi data eksternal/datasource.
- `repositories/`: Sumber data tunggal dan perantara logika data.
- `providers/`: Pengelolaan state dan notifikasi perubahan data.
- `screens/`: Antarmuka layar aplikasi.
- `widgets/`: Komponen UI reusable.

## Dokumentasi Endpoint REST API (Tahap 1)

- **Base URL**: `https://course-api-pearl.vercel.app`
- **Endpoint GET**: `https://course-api-pearl.vercel.app/courses`
- **HTTP Method**: GET
- **Status Code**: 200 OK
- **Resource**: courses

### Field JSON:
1. `id` (integer): ID unik course
2. `code` (string): Kode mata kuliah (contoh: MOB01)
3. `title` (string): Judul mata kuliah
4. `credits` (integer): Bobot SKS
5. `status` (string): Status mata kuliah (planned / active / done)

# Course Explorer v2 - Course Data Manager

Aplikasi manajemen mata kuliah berbasis Flutter dengan arsitektur bersih (Clean Architecture / Repository Pattern) yang terintegrasi dengan REST API dan backend database Supabase PostgreSQL.

**Identitas Mahasiswa:**
* **Nama:** Kadek Adi Saputra
* **NIM:** 2415051005
* **Program Studi:** Pendidikan Teknik Informatika
* **Institusi:** Universitas Pendidikan Ganesha

---

## Fitur Utama
* **Full CRUD Supabase:** Membaca (SELECT), menambah (INSERT), memperbarui (UPDATE), dan menghapus (DELETE) data mata kuliah langsung ke database PostgreSQL Supabase.
* **Clean Architecture & Repository Pattern:** Pemisahan ketat antara antarmuka (UI), state management (Provider), repositori, dan sumber data (DataSource Interface & Service).
* **State Management & Resilience:** Penanganan 4 kondisi UI secara reaktif (Loading, Empty, Error dengan fitur Coba Lagi/Retry, dan Data View).
* **Keamanan & Integritas Data:** Dilindungi oleh Row Level Security (RLS) dan database constraints (UNIQUE & CHECK constraints).
* **Navigasi Responsif & Favorit:** Navigasi adaptif dan fitur favorit berbasis kode mata kuliah yang konsisten di semua layar.

---

## Arsitektur Aplikasi
```text
lib/
├── constants/      # Kredensial & konfigurasi Supabase
├── models/         # Entity & serialisasi JSON Course
├── providers/      # State management (ChangeNotifierProvider)
├── repositories/   # CourseRepository (abstraksi bisnis)
├── services/       # CourseDataSource, CourseApiService, CourseSupabaseService
└── screens/        # Komponen tampilan antarmuka (UI)

Cara Menjalankan Aplikasi
Clone repository ini:

Bash
git clone [https://github.com/adisaputra-netizen/flutter_ui_fundamentals.git](https://github.com/adisaputra-netizen/flutter_ui_fundamentals.git)
cd flutter_ui_fundamentals
Pasang dependensi Flutter:

Bash
flutter pub get
Konfigurasikan URL dan Anon Key Supabase pada file lib/constants/supabase_constants.dart.

Jalankan aplikasi:

Bash
flutter run

---

**2. Commit dan Push README.md (Poin 97 & 98)**

Buka terminal di root proyek, lalu jalankan:

```bash
git add README.md
git commit -m "docs: tambahkan dokumentasi lengkap README.md"
git push