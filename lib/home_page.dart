// lib/home_page.dart
import 'dart:math';
import 'package:excelerate/models/course_model.dart';
import 'package:excelerate/explore_page.dart';
import 'package:excelerate/my_courses_page.dart';
import 'package:excelerate/profile_page.dart';
import 'package:excelerate/course_details_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:excelerate/mock_courses.dart'; // contains allCourses

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Shared courses list
  final List<Course> _allCourses = allCourses;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Container(), // placeholder for Home
      const ExplorePage(),
      MyCoursesPage(
        allCourses: _allCourses,
        onProgressUpdated: () => setState(() {}), // refresh Home when progress changes
      ),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ------------------ Home Page Helpers ------------------
  List<Course> get _startedCourses =>
      _allCourses.where((c) => c.lessonsList.any((l) => l['status'] != 'Locked')).toList();

  List<Course> get _completedCourses =>
      _startedCourses.where((c) => c.lessonsList.isNotEmpty && c.lessonsList.every((l) => l['status'] == 'Completed')).toList();

  double _calculateOverallProgress() {
    if (_startedCourses.isEmpty) return 0.0;
    double totalProgress = _startedCourses
        .map((c) => c.lessonsList.isEmpty
            ? 0.0
            : c.lessonsList.where((l) => l['status'] == 'Completed').length / c.lessonsList.length)
        .reduce((a, b) => a + b);
    return totalProgress / _startedCourses.length;
  }

  // ------------------ Random Courses for Continue Learning ------------------
  List<Course> _randomContinueLearningCourses(int count) {
    List<Course> shuffled = List.from(_allCourses);
    shuffled.shuffle(Random());
    return shuffled.take(min(count, shuffled.length)).toList();
  }

  // ------------------ Navigation Helpers ------------------
  void _openMyCourses({String category = 'All'}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyCoursesPage(
          allCourses: _allCourses,
          onProgressUpdated: () => setState(() {}),
        ),
        settings: RouteSettings(arguments: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    double overallProgress = _calculateOverallProgress();
    int completedCourses = _completedCourses.length;
    int startedCourses = _startedCourses.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/excelerateLogo0.png', height: 100),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications, size: 26),
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? _homeContent(context, currentUser, overallProgress, completedCourses, startedCourses)
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // ------------------ Home Page Content ------------------
  Widget _homeContent(BuildContext context, User? currentUser, double overallProgress,
      int completedCourses, int startedCourses) {
    final startedCoursesList = _startedCourses;
    final continueLearningCourses = _randomContinueLearningCourses(3);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${currentUser?.displayName ?? currentUser?.email ?? 'User'}! 👋',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready to continue your learning today?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Progress card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: overallProgress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white30,
                    progressColor: Colors.white,
                    barRadius: const Radius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    startedCourses == 0
                        ? '0 out of 0 courses completed'
                        : '$completedCourses out of $startedCourses course${startedCourses > 1 ? 's' : ''} completed',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => _openMyCourses(category: 'All'), // ✅ Open MyCoursesPage
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Quick Action Rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExplorePage())),
                  child: _quickAction(Icons.explore, 'Explore'),
                ),
                GestureDetector(
                  onTap: () => _openMyCourses(category: 'Saved'),
                  child: _quickAction(Icons.favorite, 'Saved'),
                ),
                GestureDetector(
                  onTap: () => _openMyCourses(category: 'In Progress'),
                  child: _quickAction(Icons.bar_chart, 'In Progress'),
                ),
                _quickAction(Icons.emoji_events, 'Achievements'),
              ],
            ),

            const SizedBox(height: 24),
            // ---------------- Your Courses Section ----------------
            const Text(
              'Your Courses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (startedCoursesList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No courses started yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              )
            else
              Column(
                children: startedCoursesList
                    .map(
                      (course) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailsPage(course: course, allCourses: _allCourses),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: _courseCard(
                            color: Colors.pinkAccent.withAlpha(40),
                            title: course.title,
                            category: course.category,
                            lessons: course.lessons,
                            rating: course.rating,
                            progress: course.lessonsList.isEmpty
                                ? 0.0
                                : course.lessonsList
                                        .where((l) => l['status'] == 'Completed')
                                        .length /
                                    course.lessonsList.length,
                            icon: course.icon,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 24),
            // ---------------- Continue Learning Section ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Continue Learning',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExplorePage()),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: continueLearningCourses
                  .map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(course: course, allCourses: _allCourses),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        child: _courseCard(
                          color: Colors.pinkAccent.withAlpha(40),
                          title: course.title,
                          category: course.category,
                          lessons: course.lessons,
                          rating: course.rating,
                          progress: course.lessonsList.isEmpty
                              ? 0.0
                              : course.lessonsList
                                      .where((l) => l['status'] == 'Completed')
                                      .length /
                                  course.lessonsList.length,
                          icon: course.icon,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.pinkAccent, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

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
            color: Colors.grey.withAlpha(40),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                        color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey.shade900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('$lessons lessons',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('$rating (2.3k)',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
