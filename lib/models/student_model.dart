class StudentProfile {
  final String name;
  final String nim;
  final String program;
  final String university;

  StudentProfile({
    required this.name,
    required this.nim,
    required this.program,
    required this.university,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      name: json['name'] as String? ?? '',
      nim: json['nim'] as String? ?? '',
      program: json['program'] as String? ?? '',
      university: json['university'] as String? ?? '',
    );
  }
}

class CourseItem {
  final String code;
  final String title;
  final int credits;
  final String status;
  final String grade;
  final int semester;

  CourseItem({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    required this.grade,
    required this.semester,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      status: json['status'] as String? ?? 'Rencana',
      grade: json['grade'] as String? ?? '-',
      semester: json['semester'] as int? ?? 1,
    );
  }
}

class DashboardData {
  final StudentProfile student;
  final List<CourseItem> courses;

  DashboardData({required this.student, required this.courses});
}