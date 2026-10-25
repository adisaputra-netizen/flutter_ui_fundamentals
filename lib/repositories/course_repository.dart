import '../models/course_item.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.apiService);
  final CourseApiService apiService;

  Future<List<Course>> getCourses() async {
    return await apiService.getCourses();
  }

  Future<Course> createCourse(Course course) async {
    return await apiService.createCourse(course);
  }

  Future<void> updateCourse(int id, Course course) async {
    await apiService.updateCourse(id, course);
  }

  Future<void> deleteCourse(int id) async {
    await apiService.deleteCourse(id);
  }
}