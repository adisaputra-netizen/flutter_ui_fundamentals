import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib muncul di UI dan Kode)
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
      title: 'Tahap 4 - Expanded, Flexible, & Wrap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlexWrapDemoPage(),
    );
  }
}

class FlexWrapDemoPage extends StatelessWidget {
  const FlexWrapDemoPage({super.key});

  // Minimal 6 data skills
  final List<String> skills = const [
    'Flutter SDK',
    'Responsive Design',
    'Expanded & Flex',
    'Wrap Layout',
    'MediaQuery',
    'LayoutBuilder',
    'Dart OOP',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - Flex & Wrap'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas
            Card(
              color: Colors.deepPurple.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. Demonstrasi Expanded dengan Flex 2 : 1
            const Text(
              '1. Dua Panel dengan Flex (2 : 1)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex: 2 (66.6% Ruang)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex: 1 (33.3%)',
                      style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Demonstrasi Wrap vs Row
            const Text(
              '2. Tag Kemampuan Menggunakan Wrap',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Wrap secara otomatis menurunkan chip ke baris berikutnya jika layar sempit:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                spacing: 8.0, // Jarak horizontal antar-chip
                runSpacing: 8.0, // Jarak vertikal saat pindah ke baris baru
                children: skills
                    .map((item) => Chip(
                          avatar: const Icon(Icons.check_circle, size: 18, color: Colors.deepPurple),
                          label: Text(item),
                          backgroundColor: Colors.deepPurple.shade50,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}