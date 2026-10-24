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
}