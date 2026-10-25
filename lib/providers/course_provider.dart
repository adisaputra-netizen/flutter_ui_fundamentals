import 'package:flutter/foundation.dart';
import '../models/course_item.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);
  final CourseRepository _repository;

  List<Course> _courses = [];
  final Set<String> _favoriteCodes = {};
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  Set<String> get favoriteCodes => _favoriteCodes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- TAMBAHKAN DUA GETTER INI ---
  int get favoritesCount => _favoriteCodes.length;
  int get coursesCount => _courses.length;
  // --------------------------------

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String code) => _favoriteCodes.contains(code);

  void toggleFavorite(String code) {
    if (_favoriteCodes.contains(code)) {
      _favoriteCodes.remove(code);
    } else {
      _favoriteCodes.add(code);
    }
    notifyListeners();
  }

  // Tambahkan method ini di dalam class CourseProvider:
  Future<bool> addCourse(Course course) async {
    try {
      await _repository.createCourse(course);
      await loadCourses(); // Poin 40: Refresh list setelah berhasil
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCourse(int id, Course course) async {
    try {
      await _repository.updateCourse(id, course);
      await loadCourses(); // Poin 45: refresh data
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> deleteCourse(Course course) async {
    if (course.id == null) return false;

    try {
      // 1. Request DELETE ke API
      await _repository.deleteCourse(course.id!);

      // 2. Poin 51: Hapus dari daftar favorit jika ada (cegah data yatim)
      if (_favoriteCodes.contains(course.code)) {
        _favoriteCodes.remove(course.code);
      }

      // 3. Poin 49: Refresh daftar data
      await loadCourses();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}