import 'package:flutter/material.dart';

const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQueryDemoPage(),
    );
  }
}

class MediaQueryDemoPage extends StatelessWidget {
  const MediaQueryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca karakteristik layar menggunakan MediaQuery
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Kondisi sesuai instruksi modul: jika width < 600 tampilkan 'Compact', selain itu 'Wide'
    final String layoutCategory = size.width < 600 ? 'Compact' : 'Wide';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - MediaQuery Demo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa (Wajib)
            Text(
              'Identitas: $studentId - $studentName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24, thickness: 1.5),

            // Informasi Layar dari MediaQuery
            Text(
              'Width: ${size.width.toStringAsFixed(0)} dp',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Height: ${size.height.toStringAsFixed(0)} dp',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Orientation: ${orientation.name.toUpperCase()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Kategori Layout Berdasarkan Breakpoint Lebar Layar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: size.width < 600 ? Colors.orange.shade100 : Colors.teal.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: size.width < 600 ? Colors.orange : Colors.teal,
                  width: 1.5,
                ),
              ),
              child: Text(
                'Layout Category: $layoutCategory',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: size.width < 600 ? Colors.orange.shade900 : Colors.teal.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}