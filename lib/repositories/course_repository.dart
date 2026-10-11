import '../models/course_item.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<CourseItem>> getCourses() async {
    // Simulasi delay request data selama 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));
    return service.getInitialCourses();
  }
}