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

  // Method mutasi diisi UnimplementedError() sementara sesuai instruksi modul
  @override
  Future<Course> createCourse(Course course) =>
      throw UnimplementedError();

  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) =>
      throw UnimplementedError();
}