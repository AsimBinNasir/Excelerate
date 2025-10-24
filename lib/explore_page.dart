import 'package:excelerate/mock_courses.dart';
import 'package:excelerate/models/course_model.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = categories;

  final List<Course> _allCourses = allCourses;

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _allCourses.where((course) {
      final matchesCategory =
          _selectedCategory == 'All' || course.category == _selectedCategory;
      final matchesSearch = course.title.toString().toLowerCase().contains(
        _searchQuery,
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Explore Courses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),

              // Search box
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search courses, topics...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.pinkAccent,
                    ),
                    hintStyle: TextStyle(color: Colors.grey.shade500),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.pinkAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

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
}) {
  return Container(
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
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 50)),
          ),
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
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$rating (2.3k)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 8),

              /* // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  color: Colors.pinkAccent,
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 6,
                ),
              ),

              // Progress percentage
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ), */
            ],
          ),
        ),
      ],
    ),
  );
}
