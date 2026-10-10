import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_item.dart';
import '../providers/course_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseItem course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseProvider>();
    final liveCourse = notifier.courses.firstWhere((c) => c.code == course.code);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          liveCourse.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${liveCourse.code} • ${liveCourse.status.toUpperCase()}',
                    style: const TextStyle(
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    liveCourse.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF19426D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    liveCourse.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CourseProvider>().toggleFavorite(liveCourse);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: liveCourse.isFavorite ? Colors.red : const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(liveCourse.isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(
                liveCourse.isFavorite ? 'Hapus dari Favorit' : 'Tambahkan ke Favorit',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}