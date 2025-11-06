import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:excelerate/signin.dart';
// import 'package:excelerate/models/course_model.dart'; // ✅ to access Course
import 'package:excelerate/mock_courses.dart'; // ✅ contains allCourses (used in MyCoursesPage)

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  bool _isSigningOut = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  int totalCourses = 0;
  int totalHours = 0;
  int totalCertificates = 0;

  @override
  void initState() {
    super.initState();
    _calculateCourseStats();
  }

  /// ✅ Calculate stats dynamically from allCourses list
 void _calculateCourseStats() {
  int courseCount = 0;
  double hourCount = 0; // changed to double to handle fractional hours
  int certCount = 0;

  for (var c in allCourses) {
    bool isStarted = c.lessonsList.any((l) => l['status'] != 'Locked');
    bool isCompleted = c.lessonsList.isNotEmpty &&
        c.lessonsList.every((l) => l['status'] == 'Completed');

    if (isStarted || isCompleted) courseCount++;
    if (isCompleted) {
      certCount++;
     hourCount += c.totalTime.toDouble();

    }
  }

  setState(() {
    totalCourses = courseCount;
    totalHours = hourCount.toInt(); // convert to int for display
    totalCertificates = certCount;
  });
}


  /// ✅ Sign Out Logic
  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentUser?.displayName ?? 'User Name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser?.email ?? 'No Email Found',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Dynamic Course Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(value: "$totalCourses", label: "Courses"),
                    _StatItem(value: "$totalHours", label: "Hours"),
                    _StatItem(value: "$totalCertificates", label: "Certificates"),
                  ],
                ),

                const SizedBox(height: 20),

                // Account Section
                const _SectionTitle(title: "Account"),
                const _ListTileItem(
                  icon: Icons.edit,
                  title: "Edit Profile",
                  subtitle: "Update your namme",
                ),
                const _ListTileItem(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  subtitle: "Update your security settings",
                ),
                const SizedBox(height: 15),

                // Preferences Section
                const _SectionTitle(title: "Preferences"),
                const _ListTileItem(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  subtitle: "Manage notifications",
                ),
                _ListTileItem(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (v) {
                      setState(() => isDarkMode = v);
                    },
                  ),
                ),
                const _ListTileItem(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English (US)",
                ),
                const SizedBox(height: 15),

                // Support Section
                const _SectionTitle(title: "Support"),
                const _ListTileItem(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "Get answers to your questions",
                ),
                const _ListTileItem(
                  icon: Icons.support_agent,
                  title: "Contact Support",
                  subtitle: "We are here to help",
                ),
                const _ListTileItem(
                  icon: Icons.star_border,
                  title: "Rate Our App",
                  subtitle: "Share your feedback",
                ),
                const SizedBox(height: 15),

                // Legal Section
                const _SectionTitle(title: "Legal"),
                const _ListTileItem(
                  icon: Icons.description_outlined,
                  title: "Terms of Service",
                  subtitle: "Read our terms",
                ),
                const _ListTileItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  subtitle: "How we protect your data",
                ),
                const SizedBox(height: 50),

                // Sign Out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _isSigningOut ? null : _signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSigningOut
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Signing Out...',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          )
                        : const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Version 1.0.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),

        if (_isSigningOut)
          Container(
            color: Colors.black.withAlpha(80),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}

// Helper Classes (no UI change)
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ListTileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _ListTileItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}
