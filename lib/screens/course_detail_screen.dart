import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_item.dart';
import '../providers/course_provider.dart';
import 'edit_course_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  // Fungsi konfirmasi dialog hapus
  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Course'),
        content: Text('Yakin ingin menghapus course "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    // Jika pengguna memilih Batal
    if (confirm != true) return;

    // Poin 48: Jalankan DELETE
    final provider = context.read<CourseProvider>();
    final success = await provider.deleteCourse(course);

    // Poin 50: Periksa context.mounted setelah await
    if (!context.mounted) return;

    if (success) {
      // Poin 49: Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil dihapus!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      // Kembali ke layar sebelumnya (CoursesScreen)
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: ${provider.error ?? "Terjadi kesalahan"}'),
          backgroundColor: Colors.grey[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: const Color(0xFF1976D2),
        actions: [
          // Tombol Edit
          IconButton(
            icon: const Icon(Icons.edit),
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
          // Poin 46: Tombol Delete
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Course',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode: ${course.code}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'SKS: ${course.credits}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${course.status}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}