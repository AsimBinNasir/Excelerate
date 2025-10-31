import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService {
  static const _usersKey = 'mock_users';

  // Simulated in-memory user db
  // final List<Map<String, String>> _users = [];
  // replaced by usersKey after introducing shared_preferences

  // Simulate network delay
  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Load users from local storage
  Future<List<Map<String, String>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  // Save users to local storage
  Future<void> _saveUsers(List<Map<String, String>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  // Register new user
  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _simulatedNetworkDelay();
    final users = await _loadUsers();

    // Check if email exists
    final exists = users.any((u) => u['email'] == email);
    if (exists) {
      return {'success': false, 'message': 'Email already registered'};
    }

    // Add if it doesn't
    users.add({'name': fullName, 'email': email, 'password': password});

    // Save users after adding
    await _saveUsers(users);
    return {'success': true, 'message': 'Account created successfully'};
  }

  // Log in user
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    await _simulatedNetworkDelay();
    final users = await _loadUsers();

    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      return {'success': false, 'message': 'Invalid email or password'};
    }

    return {'success': true, 'message': 'Login successful', 'user': user};
  }

  // Log out
  Future<void> signOut() async {
    // clear out a current user after saved in login process
  }
}
