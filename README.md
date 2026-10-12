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

### Tanggung Jawab Struktur Folder:
- **`models/`**: Menyimpan representasi struktur data murni (Plain Dart Objects) seperti `CourseItem` yang digunakan di seluruh lapisan aplikasi.
- **`services/`**: Bertanggung jawab langsung atas pengambilan data mentah dari sumber eksternal (API / Remote / Local Assets). Tidak memiliki ketergantungan pada UI/Widget.
- **`repositories/`**: Berfungsi sebagai abstraksi perantara (Single Source of Truth) antara data source dan state management, menyaring serta mentransformasi data mentah dari service.
- **`providers/`**: Mengelola state aplikasi (bisnis logika, loading state, error handling, notifikasi perubahan UI). Tidak menyimpan referensi `BuildContext`.
- **`screens/`**: Lapisan presentasi (UI) yang bertugas menampilkan data dari Provider dan mendengarkan event pengguna. Bebas dari logika pemanggilan API langsung maupun parsing JSON.
- **`widgets/`**: Komponen antarmuka modular (reusable UI) yang dapat digunakan berulang di berbagai screen.