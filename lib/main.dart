import 'dart:convert';
import 'package:flutter/material.dart';

// Identitas Mahasiswa
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

// Data JSON statik dari pertemuan sebelumnya
const String rawCourseJson = '''
{
  "student": {
    "name": "Kadek Adi Saputra",
    "nim": "2415051005",
    "program": "Pendidikan Teknik Informatika",
    "university": "Universitas Pendidikan Ganesha"
  },
  "courses": [
    {
      "code": "PTI2101",
      "title": "Pemrograman Mobile",
      "credits": 3,
      "status": "Selesai",
      "grade": "A",
      "semester": 5
    },
    {
      "code": "PTI2102",
      "title": "Struktur Data & Algoritma",
      "credits": 3,
      "status": "Selesai",
      "grade": "A",
      "semester": 3
    },
    {
      "code": "PTI2103",
      "title": "Rekayasa Perangkat Lunak",
      "credits": 3,
      "status": "Selesai",
      "grade": "A-",
      "semester": 4
    },
    {
      "code": "PTI2104",
      "title": "Jaringan Komputer",
      "credits": 3,
      "status": "Sedang Diambil",
      "grade": "-",
      "semester": 5
    },
    {
      "code": "PTI2105",
      "title": "Pengolahan Citra Digital",
      "credits": 2,
      "status": "Sedang Diambil",
      "grade": "-",
      "semester": 5
    },
    {
      "code": "PTI2106",
      "title": "Kapita Selekta Informatika",
      "credits": 2,
      "status": "Rencana",
      "grade": "-",
      "semester": 6
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
      title: 'Tahap 5 - GridView Responsif',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ResponsiveGridPage(),
    );
  }
}

class ResponsiveGridPage extends StatefulWidget {
  const ResponsiveGridPage({super.key});

  @override
  State<ResponsiveGridPage> createState() => _ResponsiveGridPageState();
}

class _ResponsiveGridPageState extends State<ResponsiveGridPage> {
  late List<dynamic> courses;

  @override
  void initState() {
    super.initState();
    // Parse JSON langsung ke format List of Map
    final Map<String, dynamic> parsedData = jsonDecode(rawCourseJson);
    courses = parsedData['courses'] as List<dynamic>;
  }

  // Breakpoint penentu jumlah kolom
  int columnsFor(double width) {
    if (width < 600) return 1; // Compact: 1 Kolom
    if (width < 840) return 2; // Medium: 2 Kolom
    return 3;                  // Expanded: 3 Kolom
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - GridView Responsif'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columnCount = columnsFor(constraints.maxWidth);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Identitas Mahasiswa
                Card(
                  color: Colors.teal.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.school, color: Colors.teal),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$studentId - $studentName',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Lebar: ${constraints.maxWidth.toStringAsFixed(1)} dp | Kolom: $columnCount',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            columnCount == 1 ? 'Compact' : (columnCount == 2 ? 'Medium' : 'Expanded'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Responsive GridView dari data JSON
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: columnCount == 1 ? 2.8 : 2.0,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final item = courses[index] as Map<String, dynamic>;
                      final status = item['status'] as String;

                      Color statusColor = Colors.grey;
                      if (status == 'Selesai') statusColor = Colors.green;
                      if (status == 'Sedang Diambil') statusColor = Colors.orange;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: statusColor.withOpacity(0.2),
                                child: Text(
                                  '${item['credits']}S',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['code']} • Sem ${item['semester']} • Nilai: ${item['grade']}',
                                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      status,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}