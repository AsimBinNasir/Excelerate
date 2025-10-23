import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      //appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                  const Text(
                    'Sarah Anderson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'sarah.anderson@email.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                  
                ],
              ),
            ),

            const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(value: "12", label: "Courses"),
                      _statItem(value: "45", label: "Hours"),
                      _statItem(value: "8", label: "Certificates"),
                    ],
                  ),
            const SizedBox(height: 20),

            // Account
            _SectionTitle(title: "Account"),
            _ListTileItem(
              icon: Icons.edit,
              title: "Edit Profile",
              subtitle: "Update your personal information",
            ),
            _ListTileItem(
              icon: Icons.lock_outline,
              title: "Change Password",
              subtitle: "Update your security settings",
            ),
            const SizedBox(height: 15),

            // Preferences
            _SectionTitle(title: "Preferences"),
            _ListTileItem(
              icon: Icons.notifications_none,
              title: "Notifications",
              subtitle: "Manage notification preferences",
            ),
            _ListTileItem(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              trailing: Switch(value: false, onChanged: (v) {}),
            ),
            _ListTileItem(
              icon: Icons.language,
              title: "Language",
              subtitle: "English (US)",
            ),
            const SizedBox(height: 15),

            // Support
            _SectionTitle(title: "Support"),
            _ListTileItem(
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "Get answers to your questions",
            ),
            _ListTileItem(
              icon: Icons.support_agent,
              title: "Contact Support",
              subtitle: "We're here to help",
            ),
            _ListTileItem(
              icon: Icons.star_border,
              title: "Rate Our App",
              subtitle: "Share your feedback",
            ),
            const SizedBox(height: 15),

            // Legal
            _SectionTitle(title: "Legal"),
            _ListTileItem(
              icon: Icons.description_outlined,
              title: "Terms of Service",
              subtitle: "Read our terms",
            ),
            _ListTileItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "How we protect your data",
            ),
            const SizedBox(height: 50),

            // Sign-out button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// Helper widgets
class _statItem extends StatelessWidget {
  final String value;
  final String label;
  const _statItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
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
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
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
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      color: Colors.white,
    );
  }
}
