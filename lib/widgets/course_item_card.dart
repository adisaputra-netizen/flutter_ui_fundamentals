import 'package:flutter/material.dart';
import '../models/student_model.dart';

class CourseItemCard extends StatelessWidget {
  final CourseItem course;

  const CourseItemCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final bool isFinished = course.status == 'Selesai';
    final bool isInProgress = course.status == 'Sedang Diambil';

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.hourglass_empty;

    if (isFinished) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isInProgress) {
      statusColor = Colors.orange;
      statusIcon = Icons.timelapse;
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isFinished ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: statusColor.withValues(alpha: 0.15),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(
          course.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Kode: ${course.code} • ${course.credits} SKS • Smt ${course.semester} • Nilai: ${course.grade}',
          style: const TextStyle(fontSize: 11, color: Colors.black87),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            course.status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}