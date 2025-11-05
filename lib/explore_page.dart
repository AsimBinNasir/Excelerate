// lib/explore_page.dart
import 'package:flutter/material.dart';
import 'package:excelerate/models/course_model.dart';
import 'package:excelerate/course_details_page.dart';
import 'package:excelerate/mock_courses.dart';

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
  void initState() {
    super.initState();
    // No auto-start here: courses remain Not Started until the user clicks Start Course in details.
  }

  void _refresh() {
    setState(() {});
  }

  bool _isCourseStarted(Course c) {
    return c.lessonsList.any((l) => l['status'] != 'Locked');
  }

  double _progress(Course c) {
    final total = c.lessonsList.length;
    if (total == 0) return 0.0;
    final completed = c.lessonsList.where((l) => l['status'] == 'Completed').length;
    return completed / total;
  }

  String _statusLabel(Course c) {
    if (c.lessonsList.isNotEmpty && c.lessonsList.every((l) => l['status'] == 'Completed')) {
      return 'Completed';
    }
    if (_isCourseStarted(c)) return 'In Progress';
    return ''; // Not started -> no status line shown
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _allCourses.where((course) {
      final matchesCategory = _selectedCategory == 'All' || course.category == _selectedCategory;
      final matchesSearch = course.title.toLowerCase().contains(_searchQuery);
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
              Text(
                'Explore Courses',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              _buildSearchBox(),
              _buildCategoryFilter(),
              const SizedBox(height: 20),
              Column(
                children: filteredCourses.map((course) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _courseCard(
                      course: course,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailsPage(course: course, allCourses: _allCourses),
                          ),
                        );
                        _refresh();
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

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses, topics...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
          hintStyle: TextStyle(color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
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
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700),
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _courseCard({required Course course, required VoidCallback onTap}) {
    Color color = course.category == 'Web Development'
        ? Colors.blue
        : course.category == 'Design'
            ? Colors.green
            : course.category == 'Mobile Development'
                ? Colors.orange
                : Colors.red;

    final started = _isCourseStarted(course);
    final progressPct = _progress(course);
    final statusLabel = _statusLabel(course);

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
                color: color,
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
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // status on first line (if present)
                          if (statusLabel.isNotEmpty)
                            Text(statusLabel,
                                style: TextStyle(
                                    color: statusLabel == 'Completed' ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          if (course.isSaved)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bookmark, size: 16, color: Colors.pinkAccent),
                                  const SizedBox(width: 4),
                                  Text('Saved', style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${course.lessons} lessons', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(width: 12),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${course.rating} (${course.reviews})', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: started
                        ? Column(
                            key: ValueKey('progress-${course.id}-${course.lessonsList.hashCode}'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progressPct,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('${(progressPct * 100).round()}% completed',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          )
                        : SizedBox(key: ValueKey('no-progress-${course.id}'), height: 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
