import 'package:excelerate/courseDetailsPage.dart';
import 'package:excelerate/mockCourses.dart';
import 'package:excelerate/models/courseModel.dart';
import 'package:flutter/material.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'In Progress', 'Saved', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _selectedCategory == 'All'
        ? allCourses
              .where(
                (course) =>
                    course.status == 'In Progress' ||
                    course.status == 'Completed' ||
                    course.status == 'Saved',
              )
              .toList()
        : allCourses
              .where((course) => course.status == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xf9fafbff),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    final bool isSelected = _selectedCategory == category;
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

              // Course Cards
              if (filteredCourses.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _courseCard(
                        color: course.category == 'Web Development'
                            ? Colors.blue
                            : course.category == 'Design'
                            ? Colors.green
                            : course.category == 'Mobile Development'
                            ? Colors.orange
                            : Colors.red,
                        title: course.title,
                        category: course.category,
                        lessons: course.lessons,
                        rating: course.rating,
                        progress: course.progress,
                        icon: course.icon,
                        status: course.status,
                        context: context
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

// Course Card Widget
Widget _courseCard({
  required Color color,
  required String title,
  required String category,
  required int lessons,
  required double rating,
  required double progress,
  required String icon,
  String? status,
  BuildContext? context,
}) {
  return GestureDetector(
    onTap: () {
      if (context != null) {
        // Course model to pass details
        final course = Course(
          title: title,
          category: category,
          lessons: lessons,
          rating: rating,
          progress: progress,
          icon: icon,
          status: "Completed",
          instructor: "David Bane",
          role: "Instructor",
          students: 400,
          duration: 4,
          reviews: 30,
          numStudents: 45,
          description: "Complete study soon",
          totalTime: 2,
          lessonsList: List.generate(
            lessons,
            (i) => {
              'title': '${i + 1}',
              'duration': '${10 + i} min',
              'status': i == 0
                  ? 'In Progress'
                  : (i < 3 ? 'Completed' : 'Locked'),
            },
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
          ),
        );
      }
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
                  color: status == 'Completed'
                      ? Colors.lightGreen[800]
                      : status == 'In Progress'
                      ? Colors.amberAccent[700]
                      : status == 'Saved'
                      ? Colors.pinkAccent[700]
                      : Colors.grey.shade500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 50)),
                ),
              ),
              // if check status if null
              if (status != null && status.isNotEmpty)
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
                      status,
                      style: TextStyle(
                        color: status == 'Completed'
                            ? Colors.lightGreen[800]
                            : status == 'In Progress'
                            ? Colors.amberAccent[700]
                            : status == 'Saved'
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
                    category,
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
                  title,
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
                      '$lessons lessons',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '$rating (2.3k)',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
                        '${(progress * 100).toInt()}%',
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
                    value: progress,
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
