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
      title: 'Tahap 7 - Navigation Push & Pop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// -----------------------------------------------------------------
// 1. SCREEN AWAL: HomePage
// -----------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - Home Page'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Identitas Mahasiswa
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Praktikum Navigasi Multi-Screen',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mahasiswa: $studentName ($studentId)',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Tekan tombol di bawah untuk menambah halaman baru ke atas Navigation Stack menggunakan Navigator.push():',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Tombol Buka Detail (Navigator.push)
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Buka Detail Page'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Menumpuk DetailPage ke atas stack
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 2. SCREEN KEDUA: DetailPage
// -----------------------------------------------------------------
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        // AppBar secara otomatis menyediakan tombol panah kembali (Navigator.pop)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Anda Berada di Halaman Detail!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Route ini berada di puncak navigation stack. Anda dapat kembali menggunakan tombol back bawaan AppBar atau tombol di bawah.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Kembali Kustom (Navigator.pop)
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Home (Navigator.pop)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Menghapus DetailPage dari stack dan kembali ke HomePage
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}