// lib/models/course_model.dart
import 'package:flutter/material.dart';

class Course {
  final int id;
  final String title;
  final String category;
  final String icon;
  final int lessons;
  final double rating;
  final double progress; // initial progress (kept for compatibility)
  final String status; // "Not Started", "In Progress", "Completed"
  final String instructor;
  final String role;
  final int students;
  final double duration;
  final int reviews;
  final int numStudents;
  final String description;
  final double totalTime;
  final List<Map<String, dynamic>> lessonsList;
  final BuildContext? context;

  // bookmark/save flag (mutable)
  bool isSaved;

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.lessons,
    required this.rating,
    required this.progress,
    required this.status,
    required this.instructor,
    required this.role,
    required this.students,
    required this.duration,
    required this.reviews,
    required this.numStudents,
    required this.description,
    required this.totalTime,
    required this.lessonsList,
    this.context,
    this.isSaved = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      icon: json['icon'],
      lessons: json['lessons'],
      rating: (json['rating'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      status: json['status'] ?? 'Not Started',
      instructor: json['instructor'] ?? '',
      role: json['role'] ?? '',
      students: json['students'] ?? 0,
      duration: (json['duration'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      lessonsList: List<Map<String, dynamic>>.from(json['lessonsList'] ?? []),
      numStudents: json['numStudents'] ?? 0,
      description: json['description'] ?? '',
      totalTime: (json['totalTime'] ?? 0).toDouble(),
      isSaved: json['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'icon': icon,
        'lessons': lessons,
        'rating': rating,
        'progress': progress,
        'status': status,
        'instructor': instructor,
        'role': role,
        'students': students,
        'duration': duration,
        'reviews': reviews,
        'numStudents': numStudents,
        'description': description,
        'totalTime': totalTime,
        'lessonsList': lessonsList,
        'isSaved': isSaved,
      };

  Course copyWith({
    int? id,
    String? title,
    String? category,
    String? icon,
    int? lessons,
    double? rating,
    double? progress,
    String? status,
    String? instructor,
    String? role,
    int? students,
    double? duration,
    int? reviews,
    int? numStudents,
    String? description,
    double? totalTime,
    List<Map<String, dynamic>>? lessonsList,
    BuildContext? context,
    bool? isSaved,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      lessons: lessons ?? this.lessons,
      rating: rating ?? this.rating,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      instructor: instructor ?? this.instructor,
      role: role ?? this.role,
      students: students ?? this.students,
      duration: duration ?? this.duration,
      reviews: reviews ?? this.reviews,
      numStudents: numStudents ?? this.numStudents,
      description: description ?? this.description,
      totalTime: totalTime ?? this.totalTime,
      lessonsList: lessonsList ?? this.lessonsList,
      context: context ?? this.context,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
