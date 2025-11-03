// Course model
// lib/models/courseModel.dart
import 'package:flutter/material.dart';

class Course {
  final int id;
  final String title;
  final String category;
  final String icon;
  final int lessons;
  final double rating;
  final double progress;
  final String status;
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

  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.lessons,
    required this.rating,
    required this.progress,
    required this.icon,
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
  });

  // fromJson() helper
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      lessons: json['lessons'],
      rating: (json['rating'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      icon: json['icon'],
      status: json['status'],
      instructor: json['instructor'],
      role: json['role'],
      students: json['students'],
      duration: json['duration'],
      reviews: json['reviews'],
      lessonsList: List<Map<String, dynamic>>.from(json['lessonsList']),
      numStudents: json['numStudents'],
      description: json['description'],
      totalTime: json['totalTime'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'lessons': lessons,
    'rating': rating,
    'progress': progress,
    'icon': icon,
    'instructor': instructor,
    'students': students,
    'duration': duration,
    'reviews': reviews,
    'numStudents': numStudents,
    'totalTime': totalTime,
    'description': description,
    'lessonsList': lessonsList,
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
}) {
  return Course(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    lessons: lessons ?? this.lessons,
    rating: rating ?? this.rating,
    progress: progress ?? this.progress,
    icon: icon ?? this.icon,
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
  );
}

}
