import 'package:excelerate/homepage.dart';
import 'package:excelerate/onboardingScreen.dart';
import 'package:excelerate/services/mockAuthService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _determineStartPage() async {
    final authService = MockAuthService();
    final currentUser = await authService.getCurrentUser();
    return currentUser != null ? const HomePage() : const OnboardingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: FutureBuilder(
        future: _determineStartPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
