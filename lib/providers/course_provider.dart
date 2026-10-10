import 'package:flutter/material.dart';
import '../models/course_item.dart';

class CourseProvider extends ChangeNotifier {
  final List<CourseItem> _courses = [
    CourseItem(code: 'GIT01', title: 'Git & GitHub', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB01', title: 'Dart Fundamentals', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB07', title: 'State Management', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB05', title: 'Navigation & Routing', status: 'planned', isFavorite: false),
  ];

  List<CourseItem> get courses => _courses;
  int get favoritesCount => _courses.where((c) => c.isFavorite).length;

  void toggleFavorite(CourseItem course) {
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }
}