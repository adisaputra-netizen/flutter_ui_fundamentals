import 'dart:convert';
import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib)
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

// Data JSON Pertemuan Sebelumnya
const String rawCourseJson = '''
{
  "student": {
    "name": "Kadek Adi Saputra",
    "nim": "2415051005"
  },
  "courses": [
    {
      "code": "PTI2101",
      "title": "Pemrograman Mobile",
      "credits": 3,
      "status": "Selesai",
      "grade": "A",
      "semester": 5,
      "description": "Membahas konsep arsitektur aplikasi mobile multiplatform, widget Flutter, responsive layout, navigasi antar layar, dan state management."
    },
    {
      "code": "PTI2102",
      "title": "Struktur Data & Algoritma",
      "credits": 3,
      "status": "Selesai",
      "grade": "A",
      "semester": 3,
      "description": "Mempelajari struktur data linier dan non-linier seperti linked list, stack, queue, tree, graph, serta algoritma sorting dan searching."
    },
    {
      "code": "PTI2103",
      "title": "Rekayasa Perangkat Lunak",
      "credits": 3,
      "status": "Selesai",
      "grade": "A-",
      "semester": 4,
      "description": "Konsep siklus hidup pengembangan perangkat lunak (SDLC), perancangan diagram UML, use-case, agile development, dan pengujian sistem."
    },
    {
      "code": "PTI2104",
      "title": "Jaringan Komputer",
      "credits": 3,
      "status": "Sedang Diambil",
      "grade": "-",
      "semester": 5,
      "description": "Mendalami protokol komunikasi data TCP/IP, OSI layer, subnetting IPv4/IPv6, konfigurasi routing, dan simulasi jaringan Packet Tracer."
    },
    {
      "code": "PTI2105",
      "title": "Pengolahan Citra Digital",
      "credits": 2,
      "status": "Sedang Diambil",
      "grade": "-",
      "semester": 5,
      "description": "Pengolahan visual piksel digital, operasi titik, histogram equalization, spatial filtering, konvolusi, dan deteksi tepi menggunakan Python/OpenCV."
    },
    {
      "code": "PTI2106",
      "title": "Kapita Selekta Informatika",
      "credits": 2,
      "status": "Rencana",
      "grade": "-",
      "semester": 6,
      "description": "Eksplorasi topik mutakhir dalam dunia informatika seperti kecerdasan buatan, komputasi awan, big data, dan etika profesional teknologi."
    }
  ]
}
''';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 8 - Passing Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CourseListPage(),
    );
  }
}

// -------------------------------------------------------------
// 1. SCREEN DAFTAR MATA KULIAH (CourseListPage)
// -------------------------------------------------------------
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late List<dynamic> courses;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> parsedData = jsonDecode(rawCourseJson);
    courses = parsedData['courses'] as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8 - Passing Data List'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Identitas
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.badge, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$studentId - $studentName',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Text('Pilih salah satu item untuk mengirim data ke detail',
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Daftar Course:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),

            // ListView Item Mata Kuliah
            Expanded(
              child: ListView.separated(
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final course = courses[index] as Map<String, dynamic>;
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${course['credits']}S',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                        ),
                      ),
                      title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${course['code']} • Status: ${course['status']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      // Mengirim Map course ke CourseDetailPage melalui constructor
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailPage(course: course),
                          ),
                        );
                      },
                    ),
                  );
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
// 2. SCREEN DETAIL: Menerima data melalui constructor
// -------------------------------------------------------------
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course; // Menerima data melalui constructor

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Identitas Mahasiswa di Halaman Detail
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin, color: Colors.blue, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Detail Ditinjau Oleh:', style: TextStyle(fontSize: 11, color: Colors.black54)),
                          Text('$studentName ($studentId)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card Rincian Mata Kuliah
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(course['code'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.blue.shade100,
                        ),
                        Chip(
                          label: Text('${course['status']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          backgroundColor: course['status'] == 'Selesai' ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course['title'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Beban SKS', '${course['credits']} SKS'),
                    _buildInfoRow('Semester', 'Semester ${course['semester']}'),
                    _buildInfoRow('Nilai Akhir', '${course['grade']}'),
                    const SizedBox(height: 12),
                    const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      course['description'] ?? 'Tidak ada deskripsi modul.',
                      style: const TextStyle(color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}