import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

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
        // Identitas Mahasiswa (Poin 63)
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

        // Penanganan Async State: Loading, Error, Success (Poin 60 & 61)
        if (provider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  CircularProgressIndicator(color: Color(0xFF1976D2)),
                  SizedBox(height: 12),
                  Text('Memuat data kursus...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          )
        else if (provider.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Terjadi kesalahan: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          )
        else
          // Menampilkan 3 Kursus Teratas via CourseCard modular
          ...courses.take(3).map((item) => CourseCard(item: item)),
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
}