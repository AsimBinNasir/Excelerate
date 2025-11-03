import 'package:excelerate/courseDetailsPage.dart';
import 'package:excelerate/models/courseModel.dart';
import 'package:excelerate/services/mockCourseService.dart';
import 'package:flutter/material.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final MockCourseService _courseService = MockCourseService();

  List<Course> _myCourses = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'In Progress', 'Saved', 'Completed'];

  @override
  void initState() {
    super.initState();
    _loadMyCourses();
  }

  Future<void> _loadMyCourses() async {
    await _courseService.initializeMockCourses();
    // For now all courses = my courses, addd logic later
    final allCourses = await _courseService.getAllCourses();

    setState(() {
      _myCourses = allCourses
          .map((c) => c.copyWith(status: _assignStatus(c.id)))
          .toList();
      _isLoading = false;
    });
  }

  // Randomly assign mock status
  String _assignStatus(int id) {
    if (id % 3 == 0) return 'Completed';
    if (id % 3 == 1) return 'In progress';
    return 'Saved';
  }

  List<Course> _filterCourses() {
    if (_selectedCategory == 'All') {
      return _myCourses
          .where(
            (c) =>
                c.status == 'In Progress' ||
                c.status == 'Completed' ||
                c.status == 'Saved',
          )
          .toList();
    }
    return _myCourses.where((c) => c.status == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _filterCourses();

    return Scaffold(
      backgroundColor: const Color(0xf9fafbff),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadMyCourses,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'My Courses',
                        textAlign: TextAlign.center,
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
                            final bool isSelected =
                                _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                selectedColor: Colors.pinkAccent,
                                backgroundColor: Colors.grey.shade200,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                onSelected: (_) {
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

                      // Course Cards
                      if (filteredCourses.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              'No courses found in $_selectedCategory',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: filteredCourses.map((course) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _courseCard(course, context),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// Course Card Widget
Widget _courseCard(Course course, BuildContext context) {
  return GestureDetector(
    onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
          ),
        );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 TOP SECTION (Colored background + Emoji/Icon)
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: course.status == 'Completed'
                      ? Colors.lightGreen[800]
                      : course.status == 'In Progress'
                      ? Colors.amberAccent[700]
                      : course.status == 'Saved'
                      ? Colors.pinkAccent[700]
                      : Colors.grey.shade500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(course.icon, style: const TextStyle(fontSize: 50)),
                ),
              ),
              // if check status if null
              if (course.status.isNotEmpty)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course.status,
                      style: TextStyle(
                        color: course.status == 'Completed'
                            ? Colors.lightGreen[800]
                            : course.status == 'In Progress'
                            ? Colors.amberAccent[700]
                            : course.status == 'Saved'
                            ? Colors.pinkAccent[700]
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 🔸 BOTTOM SECTION (White background + course details)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    course.category,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  course.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 8),

                // Lessons, rating & progress %
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${course.lessons} lessons',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${course.rating} (2.3k)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress'),
                    // Progress percentage
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${(course.progress * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    color: Colors.pinkAccent,
                    backgroundColor: Colors.grey.shade300,
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
