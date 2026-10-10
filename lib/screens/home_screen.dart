import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_item.dart';
import '../providers/course_provider.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final String studentId;
  final String studentName;

  const HomeScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;
    final favoritesCount = provider.favoritesCount;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Identitas Mahasiswa
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$studentId • $studentName',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19426D),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary Boxes
        Row(
          children: [
            Expanded(child: _buildSummaryBox('Courses', courses.length.toString())),
            const SizedBox(width: 14),
            Expanded(child: _buildSummaryBox('Favorites', favoritesCount.toString())),
          ],
        ),
        const SizedBox(height: 16),

        // 3 Kursus Teratas
        ...courses.take(3).map((item) => _buildCourseCard(context, item)),

        const SizedBox(height: 16),

        // Kartu Penanda Tahap 8
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF43A047), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tahap 8: Refactoring & Architecture Clean-up',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$studentId • $studentName',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Icon(Icons.folder_special, color: Color(0xFF2E7D32), size: 22),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pemisahan models, providers, dan screens selesai.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDD8F5), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF4A6887))),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19426D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailScreen(course: item)),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFBDD8F5), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF19426D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00796B),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => context.read<CourseProvider>().toggleFavorite(item),
            ),
          ],
        ),
      ),
    );
  }
}