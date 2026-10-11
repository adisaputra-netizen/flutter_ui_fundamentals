import 'package:flutter/material.dart';
import '../models/course_item.dart';
import '../services/course_service.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider({CourseRepository? repository})
      : repository = repository ?? CourseRepository(CourseService()) {
    loadCourses();
  }

  List<CourseItem> courses = [];
  final Set<String> _favorites = {'GIT01', 'MOB01'}; // Inisial kode materi favorit
  bool isLoading = false;
  String? error;

  List<String> get favorites => _favorites.toList();
  int get favoritesCount => _favorites.length;

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    _favorites.contains(code)
        ? _favorites.remove(code)
        : _favorites.add(code);
    notifyListeners();
  }

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
}