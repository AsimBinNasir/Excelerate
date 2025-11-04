// lib/home_page.dart
import 'package:excelerate/models/course_model.dart';
import 'package:excelerate/explore_page.dart';
import 'package:excelerate/my_courses_page.dart';
import 'package:excelerate/profile_page.dart';
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
  final List<Course> courseList = allCourses;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Container(), // placeholder for Home
      const ExplorePage(),
      MyCoursesPage(
        allCourses: allCourses,
        onProgressUpdated: () => setState(() {}),
      ),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Calculate average progress across all courses
  double _calculateOverallProgress() {
    if (courseList.isEmpty) return 0.0;
    double totalProgress = courseList.map((c) => c.progress).reduce((a, b) => a + b);
    return totalProgress / courseList.length;
  }

  // Count completed courses
  int _countCompletedCourses() {
    return courseList.where((c) => c.progress >= 1.0).length;
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    double overallProgress = _calculateOverallProgress();
    int completedCourses = _countCompletedCourses();

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
          ? _homeContent(context, currentUser, overallProgress, completedCourses)
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
  Widget _homeContent(
      BuildContext context, User? currentUser, double overallProgress, int completedCourses) {
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
            // Progress card (dynamic)
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
                    '$completedCourses of ${courseList.length} courses completed',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'level 3',
                        style: TextStyle(color: Colors.white),
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
                _quickAction(Icons.explore, 'Browse'),
                _quickAction(Icons.favorite, 'Favorites'),
                _quickAction(Icons.bar_chart, 'Progress'),
                _quickAction(Icons.emoji_events, 'Achievements'),
              ],
            ),
            const SizedBox(height: 24),
            // Continue Learning Section
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
            // Dynamic Course Cards
            Column(
              children: courseList
                  .where((c) => c.progress > 0.0 && c.progress < 1.0)
                  .map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _courseCard(
                        color: Colors.pinkAccent.withValues(alpha: .15),
                        title: course.title,
                        category: course.category,
                        lessons: course.lessons,
                        rating: course.rating,
                        progress: course.progress,
                        icon: course.icon,
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
            color: Colors.grey.withValues(alpha: .15),
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
                        color: Colors.grey.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey.shade900)),
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
