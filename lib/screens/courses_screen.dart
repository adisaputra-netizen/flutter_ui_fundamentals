import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../models/course_item.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        centerTitle: true,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.loadCourses(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Banner Identitas Mahasiswa
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      '2415051005 • Kadek Adi Saputra',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Tombol + Tambah Course
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      foregroundColor: Colors.teal.shade800,
                      elevation: 0,
                      side: BorderSide(color: Colors.teal.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Tambah Course',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddCourseScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Penanganan State: Loading, Error, Empty, & List Data
                if (provider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.error != null) // Menggunakan provider.error
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => provider.loadCourses(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (provider.courses.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Belum ada data course.'),
                    ),
                  )
                else
                  ...provider.courses.map(
                    (course) => _buildCourseCard(context, course, provider),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course, CourseProvider provider) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${course.code} • ${course.credits} SKS • ${course.status.toUpperCase()}',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Edit
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.blueGrey),
              tooltip: 'Edit Course',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCourseScreen(course: course),
                  ),
                );
              },
            ),
            // Tombol Delete
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.redAccent),
              tooltip: 'Hapus Course',
              onPressed: () => _confirmDelete(context, course, provider),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(course: course),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Course course, CourseProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Course?'),
        content: Text(
          'Yakin ingin menghapus ${course.title} (${course.code})? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              // Mempassing objek course secara utuh ke deleteCourse
              await provider.deleteCourse(course);

              if (context.mounted) {
                final hasError = provider.error != null;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      hasError
                          ? (provider.error ?? 'Gagal menghapus data')
                          : '${course.title} berhasil dihapus',
                    ),
                    backgroundColor: hasError ? Colors.red : Colors.green,
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}