import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/student_model.dart';

class DashboardService {
  static const String assetPath = 'assets/data/student_data.json';

  static Future<DashboardData> fetchDashboardData() async {
    // Simulasi delay pembacaan asinkron
    await Future.delayed(const Duration(milliseconds: 500));

    final String jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded = json.decode(jsonString);

    final student =
        StudentProfile.fromJson(decoded['student'] as Map<String, dynamic>);
    final coursesRaw = decoded['courses'] as List<dynamic>;
    final courses = coursesRaw
        .map((item) => CourseItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return DashboardData(student: student, courses: courses);
  }
}