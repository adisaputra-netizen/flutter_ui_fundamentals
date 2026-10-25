import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course_item.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // Poin 72: Query SELECT data dari tabel courses dengan urutan id
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    // Poin 73: Konversi response menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

 @override
  Future<Course> createCourse(Course course) async {
    // Pastikan tidak mengirim ID jika bernilai null agar digenerate otomatis oleh identity column di database
    final courseData = course.toJson()..removeWhere((key, value) => key == 'id' && value == null);

    final row = await supabase
        .from('courses')
        .insert(courseData)
        .select()
        .single();

    return Course.fromJson(row);
  }

  // Poin 83: UPDATE data berdasarkan id menggunakan Supabase client
  @override
  Future<void> updateCourse(int id, Course course) async {
    // Siapkan payload map dan hapus key id jika null agar tidak menimpa identity database
    final updateData = course.toJson()..removeWhere((key, value) => key == 'id');

    await supabase
        .from('courses')
        .update(updateData)
        .eq('id', id);
  }
  @override
  Future<void> deleteCourse(int id) =>
      throw UnimplementedError();
}