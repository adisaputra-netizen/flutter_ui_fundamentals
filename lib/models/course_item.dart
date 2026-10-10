class CourseItem {
  final String code;
  final String title;
  final String status;
  final String description;
  bool isFavorite;

  CourseItem({
    required this.code,
    required this.title,
    required this.status,
    this.description = 'Pelajari konsep inti dan praktik implementasinya secara mendalam.',
    this.isFavorite = false,
  });
}