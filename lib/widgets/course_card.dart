import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_item.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final CourseItem item;

  const CourseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: item),
          ),
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