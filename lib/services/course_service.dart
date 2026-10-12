import '../models/course_item.dart';

class CourseService {
  // Simulasi pengambilan data dari remote/lokal datasource
  List<CourseItem> getInitialCourses() { //[cite: 3]
    // AKTIFKAN INI UNTUK KASUS C:
    // throw Exception('Gagal memuat data kursus: Terjadi kesalahan pada CourseService.');
    return [
      CourseItem(code: 'GIT01', title: 'Git & GitHub', status: 'done', isFavorite: true),
      CourseItem(code: 'MOB01', title: 'Dart Fundamentals', status: 'done', isFavorite: true),
      CourseItem(code: 'MOB07', title: 'State Management', status: 'active', isFavorite: false),
      CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'active', isFavorite: false),
      CourseItem(code: 'MOB05', title: 'Navigation & Routing', status: 'planned', isFavorite: false),
    ];
  }
}