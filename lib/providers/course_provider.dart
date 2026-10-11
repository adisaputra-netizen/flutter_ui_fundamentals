import 'package:flutter/material.dart';
import '../models/course_item.dart';
import '../services/course_service.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider({CourseRepository? repository})
      : repository = repository ?? CourseRepository(CourseService()) {
    loadCourses(); // Ambil data secara asinkron saat inisialisasi
  }

  List<CourseItem> courses = [];
  bool isLoading = false;
  String? error;

  int get favoritesCount => courses.where((c) => c.isFavorite).length;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(CourseItem course) {
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }
}