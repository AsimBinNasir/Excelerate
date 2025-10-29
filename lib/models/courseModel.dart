// Course model
// lib/models/courseModel.dart
import 'package:flutter/material.dart';

class Course {
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
    this.context
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
      instructor: map['instructor'],
      role: map['role'],
      students: map['students'],
      duration: map['duration'],
      reviews: map['reviews'],
      lessonsList: [],
      numStudents: map['numStudents'],
      description: map['description'],
      totalTime: map['totalTime'],
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
