import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib)
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 9 - Returning Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CourseCatalogPage(),
    );
  }
}

// -------------------------------------------------------------
// 1. SCREEN AWAL: CourseCatalogPage (Menunggu Hasil Balikan)
// -------------------------------------------------------------
class CourseCatalogPage extends StatefulWidget {
  const CourseCatalogPage({super.key});

  @override
  State<CourseCatalogPage> createState() => _CourseCatalogPageState();
}

class _CourseCatalogPageState extends State<CourseCatalogPage> {
  // Flag status favorit lokal untuk simulasi
  bool _isMobileCourseFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 9 - Returning Data'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Identitas Mahasiswa
            Card(
              color: Colors.teal.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$studentId - $studentName',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Text('Uji coba Navigator.pop(context, result)',
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu Course
            Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: const Icon(Icons.phone_android, color: Colors.teal),
                ),
                title: const Text(
                  'Pemrograman Mobile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_isMobileCourseFavorite
                    ? 'Status: Disukai / Masuk Favorit ❤️'
                    : 'Status: Belum difavoritkan'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  // Await hasil kembalian dari DetailPage
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailFeedbackPage(
                        courseTitle: 'Pemrograman Mobile',
                        isCurrentlyFavorite: _isMobileCourseFavorite,
                      ),
                    ),
                  );

                  // Jika halaman detail mengembalikan nilai (result != null)
                  if (!mounted) return;
                  if (result != null) {
                    setState(() {
                      _isMobileCourseFavorite = result;
                    });

                    // Menampilkan feedback SnackBar sesuai instruksi modul
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result
                            ? 'Mata kuliah ditandai sebagai Favorit!'
                            : 'Mata kuliah dihapus dari Favorit.'),
                        backgroundColor: result ? Colors.teal.shade800 : Colors.grey.shade800,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. SCREEN DETAIL: CourseDetailFeedbackPage (Mengembalikan Data)
// -------------------------------------------------------------
class CourseDetailFeedbackPage extends StatelessWidget {
  final String courseTitle;
  final bool isCurrentlyFavorite;

  const CourseDetailFeedbackPage({
    super.key,
    required this.courseTitle,
    required this.isCurrentlyFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Modul: $courseTitle',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text('Mahasiswa Peninjau: $studentName ($studentId)',
                        style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Tekan tombol di bawah untuk mengubah status favorit dan mengirimkan data balik menggunakan Navigator.pop(context, result):',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Tombol yang mengembalikan data boolean ke screen sebelumnya
            ElevatedButton.icon(
              icon: Icon(isCurrentlyFavorite ? Icons.favorite_border : Icons.favorite),
              label: Text(isCurrentlyFavorite
                  ? 'Hapus dari Favorit (Kirim false)'
                  : 'Tandai sebagai Favorit (Kirim true)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentlyFavorite ? Colors.grey.shade700 : Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Mengirim boolean kebalikan ke screen awal
                Navigator.pop(context, !isCurrentlyFavorite);
              },
            ),
            const SizedBox(height: 10),

            // Tombol kembali biasa tanpa mengirim hasil
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal / Kembali Saja'),
            ),
          ],
        ),
      ),
    );
  }
}