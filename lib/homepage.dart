import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('excelerateLogo0.png', height: 40),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 20),
            ),
          ],
        ),
      ),
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
        currentIndex: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Hello, Sarah!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.waving_hand_rounded, size: 28),
                ],
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
                    color: Colors.blue[50]!,
                    title: 'Advanced React & Typescript',
                    category: 'Web Development',
                    lessons: 12,
                    rating: 4.8,
                    progress: 0.45,
                    image: 'assets/react.png',
                  ),
                  const SizedBox(height: 16),
                  _courseCard(
                    color: Colors.green[50]!,
                    title: 'UI/UX Design Fundamenntals',
                    category: 'Design',
                    lessons: 15,
                    rating: 4.9,
                    progress: 0.7,
                    image: 'assets/uiux.png',
                  ),
                  const SizedBox(height: 16),
                  _courseCard(
                    color: Colors.orange[50]!,
                    title: 'Flutter & Dart Masterclass',
                    category: 'Mobile Development',
                    lessons: 20,
                    rating: 4.7,
                    progress: 0.2,
                    image: 'assets/flutter.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quick Action Widget
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

// Course Card Widget
Widget _courseCard({
  required Color color,
  required String title,
  required String category,
  required int lessons,
  required double rating,
  required double progress,
  required String image,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 1),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Image.asset(image, height: 60)),
        const SizedBox(height: 12),
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$lessons Lessons  •  ⭐ $rating',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          color: Colors.pinkAccent,
          backgroundColor: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    ),
  );
}
