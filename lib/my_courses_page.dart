// lib/my_courses_page.dart
import 'package:flutter/material.dart';
import 'package:excelerate/models/course_model.dart';
import 'package:excelerate/course_details_page.dart';

class MyCoursesPage extends StatefulWidget {
  final List<Course> allCourses;
  final VoidCallback? onProgressUpdated; // ✅ Added callback

  const MyCoursesPage({
    super.key,
    required this.allCourses,
    this.onProgressUpdated,
  });

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  late String _selectedCategory;
  final List<String> _categories = ['All', 'In Progress', 'Saved', 'Completed'];
  bool _categoryInitialized = false; // ✅ prevent re-initialization

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_categoryInitialized) {
      _selectedCategory = ModalRoute.of(context)?.settings.arguments as String? ?? 'All';
      _categoryInitialized = true;
    }
  }

  bool _isStarted(Course c) => c.lessonsList.any((l) => l['status'] != 'Locked');
  bool _isCompleted(Course c) => c.lessonsList.isNotEmpty && c.lessonsList.every((l) => l['status'] == 'Completed');
  double _progress(Course c) {
    final total = c.lessonsList.length;
    if (total == 0) return 0.0;
    final completed = c.lessonsList.where((l) => l['status'] == 'Completed').length;
    return completed / total;
  }

  String _statusLabel(Course c) {
    if (_isCompleted(c)) return 'Completed';
    if (_isStarted(c)) return 'In Progress';
    if (c.isSaved) return 'Saved';
    return '';
  }

  List<Course> get _filteredCourses {
    return widget.allCourses.where((c) {
      switch (_selectedCategory) {
        case 'In Progress':
          return _isStarted(c) && !_isCompleted(c);
        case 'Completed':
          return _isCompleted(c);
        case 'Saved':
          return c.isSaved;
        default:
          return _isStarted(c) || _isCompleted(c) || c.isSaved;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Courses',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),

              // Filter options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final bool isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: Colors.pinkAccent,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              if (_filteredCourses.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'No courses found in $_selectedCategory',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ),
                )
              else
                Column(
                  children: _filteredCourses.map((course) {
                    final status = _statusLabel(course);
                    final progress = _progress(course);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _courseCard(
                        course: course,
                        progress: progress,
                        statusLabel: status,
                        onTap: () async {
                          final updatedCourse = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                course: course,
                                allCourses: widget.allCourses,
                              ),
                            ),
                          );

                          if (updatedCourse != null) {
                            setState(() {
                              final index =
                                  widget.allCourses.indexWhere((c) => c.id == updatedCourse.id);
                              if (index != -1) widget.allCourses[index] = updatedCourse;
                            });
                            widget.onProgressUpdated?.call(); // ✅ Notify HomePage
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Course Card Widget -----------------
Widget _courseCard({
  required Course course,
  required double progress,
  required String statusLabel,
  required VoidCallback onTap,
}) {
  Color color = course.category == 'Web Development'
      ? Colors.blue
      : course.category == 'Design'
          ? Colors.green
          : course.category == 'Mobile Development'
              ? Colors.orange
              : Colors.red;

  final started = progress > 0;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(40), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: statusLabel == 'Completed'
                  ? Colors.green.shade100
                  : statusLabel == 'In Progress'
                      ? Colors.orange.shade100
                      : statusLabel == 'Saved'
                          ? Colors.blue.shade100
                          : color,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Center(child: Text(course.icon, style: const TextStyle(fontSize: 50))),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                  child: Text(course.category, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey.shade900)),
                    ),
                    if (statusLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusLabel == 'Completed'
                              ? Colors.green.shade100
                              : statusLabel == 'In Progress'
                                  ? Colors.orange.shade100
                                  : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                              color: statusLabel == 'Completed'
                                  ? Colors.green
                                  : statusLabel == 'In Progress'
                                      ? Colors.orange
                                      : Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (started)
                  LinearProgressIndicator(
                    value: progress,
                    color: Colors.pinkAccent,
                    backgroundColor: Colors.grey.shade200,
                  ),
                if (started)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${(progress * 100).toInt()}% completed',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
