// Course model
// lib/models/courseModel.dart
class Course {
  final String title;
  final String category;
  final int lessons;
  final double rating;
  final double progress;
  final String icon;
  final String status;

  const Course({
    required this.title,
    required this.category,
    required this.lessons,
    required this.rating,
    required this.progress,
    required this.icon,
    required this.status,
  });

  // optional fromMap() helper
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      title: map['title'],
      category: map['category'],
      lessons: map['lessons'],
      rating: map['rating'],
      progress: map['progress'],
      icon: map['icon'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'lessons': lessons,
      'rating': rating,
      'progress': progress,
      'icon': icon,
      'status': status,
    };
  }
}
