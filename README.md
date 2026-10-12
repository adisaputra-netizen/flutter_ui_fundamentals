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