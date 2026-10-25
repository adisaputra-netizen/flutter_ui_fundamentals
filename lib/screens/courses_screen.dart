import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;

    // 1. Loading State
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 2. Error State (Menggunakan Widget ErrorView)
    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: () => provider.loadCourses(),
      );
    }

    // 3. Empty State (Data Kosong)
    if (courses.isEmpty) {
      return const Center(
        child: Text(
          'Data course belum tersedia',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // 4. Success State (Data Normal dengan Pull-to-Refresh)
    return RefreshIndicator(
      onRefresh: () => provider.loadCourses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final item = courses[index];
          final isFav = provider.isFavorite(item.code);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: item),
                  ),
                );
              },
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${item.code} • Status: ${item.status}'),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: () =>
                    context.read<CourseProvider>().toggleFavorite(item.code),
              ),
            ),
          );
        },
      ),
    );
  }
}