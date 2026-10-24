// Type alias agar kode lama yang memanggil CourseItem tidak error
typedef CourseItem = Course;

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final bool isFavorite; // Mendukung kode lama Pertemuan 6

  const Course({
    this.id,
    required this.code,
    required this.title,
    this.credits = 2, // Default credits jika data lama tidak punya credits
    this.status = 'planned',
    this.isFavorite = false,
  });

  // Konversi dari JSON (Map) ke object Course
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: (json['code'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 2,
      status: (json['status'] as String?) ?? 'planned',
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }

  // Konversi dari object Course ke JSON (Map)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  Course copyWith({
    int? id,
    String? code,
    String? title,
    int? credits,
    String? status,
    bool? isFavorite,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      credits: credits ?? this.credits,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}