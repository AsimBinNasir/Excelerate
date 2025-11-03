import 'dart:convert';
import 'dart:async';
import 'package:excelerate/models/courseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCourseService {
  static const _allCoursesKey = 'mock_all_courses';
  static const _myCoursesKey = 'mock_my_courses';
  static const _recentCoursesKey = 'mock_recent_courses';
  static const _continueLearningKey = 'mock_continue_learning';

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<SharedPreferences> _prefs() async =>
      await SharedPreferences.getInstance();

  // Initialize mock data on first launch
  Future<void> initializeMockCourses() async {
    final prefs = await _prefs();
    if (!prefs.containsKey(_allCoursesKey)) {
      final mockCourses = _generateMockCourses();
      await prefs.setString(_allCoursesKey, jsonEncode(mockCourses));
    }
  }

  /// Generate mock data
  List<Map<String, dynamic>> _generateMockCourses() {
    final categories = [
      'Web Development',
      'Design',
      'Mobile Development',
      'Data Science',
    ];
    final icons = ['💻', '🎨', '📱', '📊'];

    return List.generate(45, (i) {
      final category = categories[i % categories.length];
      final icon = icons[i % icons.length];

      return {
        'id': i + 1,
        'title': '$category Course ${i + 1}',
        'category': category,
        'lessons': 10 + (i % 5),
        'rating': 4.3 + (i % 3),
        'progress': 0.0,
        'icon': icon,
        'instructor': 'Instructor ${(i % 4) + 1}',
        'students': 100 + i * 5,
        'duration': 3 + (i % 3),
        'reviews': 2 + (i * 2),
        'numStudents': 40 + i,
        'totalTime': 2 + (i % 2),
        'description': 'Learn about $category with hands-on projects.',
        'lessonsList': List.generate(
          10,
          (j) => {
            'title': 'Lesson ${j + 1}',
            'duration': '${10 + j}min',
            'status': j == 0 ? 'In Progress' : (j < 3 ? 'Completed' : 'Locked'),
          },
        ),
      };
    });
  }

  // Get all courses (Explore Page)
  Future<List<Course>> getAllCourses() async {
    await _simulatedNetworkDelay();
    final prefs = await _prefs();
    final jsonString = prefs.getString(_allCoursesKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Course.fromJson(e)).toList();
  }

  // Update course progress
  Future<void> updateCourseProgress(int courseId, double progress) async {
    final prefs = await _prefs();
    final jsonString = prefs.getString(_myCoursesKey);
    if (jsonString == null) return;

    List<Map<String, dynamic>> myCourses = List<Map<String, dynamic>>.from(
      jsonDecode(jsonString),
    );
    for (var course in myCourses) {
      if (course['id'] == courseId) {
        course['progress'] == progress;
      }
    }
    await prefs.setString(_myCoursesKey, jsonEncode(myCourses));

    // Save under continue learning
    await prefs.setString(_continueLearningKey, jsonEncode(myCourses));
  }

  /// Get Continue Learning Courses (Home Page)
  Future<List<Course>> getContinueLearning() async {
    await _simulatedNetworkDelay();
    final prefs = await _prefs();
    final jsonString = prefs.getString(_continueLearningKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Course.fromJson(e)).toList();
  }

  /// Add recent course for homepage recently opened
  Future<void> addRecentCourses(Course course) async {
    final prefs = await _prefs();
    final jsonString = prefs.getString(_recentCoursesKey);
    List<Map<String, dynamic>> recentCourses = jsonString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(jsonString))
        : [];
    recentCourses.removeWhere((c) => c['id'] == course.id);
    recentCourses.insert(0, course.toJson());
    if (recentCourses.length > 5) {
      recentCourses = recentCourses.sublist(0, 5);
    }
    await prefs.setString(_recentCoursesKey, jsonEncode(recentCourses));
  }

  /// Get recent courses for home page
  Future<List<Course>> getRecentCourse() async {
    final prefs = await _prefs();
    final jsonString = prefs.getString(_recentCoursesKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Course.fromJson(e)).toList();
  }
}
