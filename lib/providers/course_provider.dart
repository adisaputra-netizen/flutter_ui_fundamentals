import 'package:flutter/material.dart';
import '../models/course_item.dart';
import '../services/course_service.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository _repository;
  late List<CourseItem> _courses;

  // Provider sekarang hanya berkomunikasi dengan Repository
  CourseProvider({CourseRepository? repository})
      : _repository = repository ?? CourseRepository(CourseService()) {
    _courses = _repository.getCourses();
  }

  List<CourseItem> get courses => _courses;
  int get favoritesCount => _courses.where((c) => c.isFavorite).length;

  void toggleFavorite(CourseItem course) {
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }
}