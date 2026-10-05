import 'package:flutter/material.dart';

// Identitas Mahasiswa
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
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 12',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const InteractionScreen(),
    );
  }
}

// Model data Course sederhana
class CourseItem {
  final String code;
  final String title;
  final String status;
  bool isFavorite;

  CourseItem({
    required this.code,
    required this.title,
    required this.status,
    this.isFavorite = false,
  });
}

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  // Daftar course dengan status favorite yang dapat diubah
  final List<CourseItem> courses = [
    CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'Active'),
    CourseItem(code: 'MOB05', title: 'Navigation Stack', status: 'Active'),
    CourseItem(code: 'MOB06', title: 'User Interaction', status: 'Active'),
    CourseItem(code: 'MOB07', title: 'State Management', status: 'Planned'),
  ];

  String lastActionLog = 'Belum ada interaksi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interaction: Card & Favorite'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Header Identitas & Log Interaksi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$studentName ($studentId)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aktivitas Terakhir: $lastActionLog',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
          // Daftar Course dengan InkWell dan GestureDetector
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  clipBehavior: Clip.antiAlias, // Agar ripple InkWell rapi di dalam card
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    // 1. Aksi Tap dengan Ripple Material
                    onTap: () {
                      setState(() {
                        lastActionLog = 'Tap pada course: ${course.title}';
                      });
                    },
                    // 2. Aksi Long Press (Gesture tambahan)
                    onLongPress: () {
                      setState(() {
                        lastActionLog = 'Long press info: ${course.code} - ${course.title}';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Detail cepat: ${course.code} berstatus ${course.status}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.school),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kode: ${course.code} • Status: ${course.status}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // 3. Tombol Favorite dengan icon aktif/nonaktif
                          IconButton(
                            icon: Icon(
                              course.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: course.isFavorite ? Colors.red : Colors.grey,
                            ),
                            tooltip: course.isFavorite
                                ? 'Hapus Favorite'
                                : 'Tambah Favorite',
                            onPressed: () {
                              setState(() {
                                course.isFavorite = !course.isFavorite;
                                lastActionLog = course.isFavorite
                                    ? '${course.title} ditambahkan ke favorit'
                                    : '${course.title} dihapus dari favorit';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}