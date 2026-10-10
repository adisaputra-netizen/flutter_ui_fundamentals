import '../models/course_item.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  List<CourseItem> getCourses() {
    return service.getInitialCourses();
  }
}