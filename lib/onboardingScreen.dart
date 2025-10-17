import 'package:excelerate/signin.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      title: "Welcome to Excelerate",
      description:
          "Transform your learning journey with personalized courses designed to help you excel in your career.",
      buttonText: "Get Started",
    ),
    _OnboardPage(
      title: "Track Your Progress",
      description:
          "Monitor your achievements, set goals, and celebrate milestones as you advance through your courses.",
      buttonText: "Continue",
    ),
    _OnboardPage(
      title: "Learn Anywhere",
      description:
          "Access your courses on any device, anytime. Learning fits your schedule, not the other way around.",
      buttonText: "Let's Begin",
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to actual sign in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2f2),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, index) {
                final page = _pages[index];
                return _buildPage(page);
              },
              itemCount: _pages.length,
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
            ),
          ),
          _buildIndicator(),
          const SizedBox(height: 30),
          _buildButton(_pages[_currentPage]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/excelerateLogo0.png', height: 240),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.grey[700] : Colors.grey[350],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(_OnboardPage page) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6A00), Color(0xFFFF00FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: TextButton(
        onPressed: _nextPage,
        child: Text(
          page.buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String title;
  final String description;
  final String buttonText;

  _OnboardPage({
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
