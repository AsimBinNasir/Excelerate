import 'package:excelerate/courseDetailsPage.dart';
import 'package:excelerate/explorePage.dart';
import 'package:excelerate/models/courseModel.dart';
import 'package:excelerate/myCoursesPage.dart';
import 'package:excelerate/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = const [
    ExplorePage(),
    MyCoursesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xf9fafbff),
      appBar: AppBar(
        backgroundColor: const Color(0xf9fafbff),
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/excelerateLogo0.png', height: 100),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 26),
            ),
          ],
        ),
      ),

      body: _selectedIndex == 0 ? _homeContent(context) : _pages[_selectedIndex - 1],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        selectedLabelStyle: TextStyle(color: Colors.purple),
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
}

// Home Page Content
Widget _homeContent(BuildContext? context) {
  return SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Hello, Sarah! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to continue your learning today?',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
              gradient: LinearGradient(
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
                  percent: 0.6,
                  backgroundColor: Colors.white30,
                  progressColor: Colors.white,
                  barRadius: const Radius.circular(10),
                ),
                const Text(
                  '3 of 5 courses completed this month',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
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
              _quickAction('📖', 'Browse'),
              _quickAction('⭐️', 'Favorites'),
              _quickAction('📊', 'Progress'),
              _quickAction('🏆', 'Achievements'),
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
                onPressed: () {},
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

          // Course Cards
          Column(
            children: [
              _courseCard(
                context: context,
                color: Colors.blue,
                title: 'Advanced React & Typescript',
                category: 'Web Development',
                lessons: 12,
                rating: 4.8,
                progress: 0.45,
                icon: '💻',
              ),
              const SizedBox(height: 16),
              _courseCard(
                context: context,
                color: Colors.green,
                title: 'UI/UX Design Fundamentals',
                category: 'Design',
                lessons: 15,
                rating: 4.9,
                progress: 0.7,
                icon: '🎨',
              ),
              const SizedBox(height: 16),
              _courseCard(
                context: context,
                color: Colors.orange,
                title: 'Flutter & Dart Masterclass',
                category: 'Mobile Development',
                lessons: 20,
                rating: 4.7,
                progress: 0.2,
                icon: '📱',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Quick Action Widget
Widget _quickAction(String emoji, String label) {
  return Container(
    width: 85,
    height: 85,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 6,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: TextStyle(fontSize: 30)),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        ),
      ],
    ),
  );
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
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '$rating (2.3k)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
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
                ), */

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
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
