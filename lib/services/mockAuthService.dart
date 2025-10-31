import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService {
  static const _usersKey = 'mock_users';
  static const _currentUserKey = 'current_user';

  // Simulated in-memory user db
  // final List<Map<String, String>> _users = [];
  // replaced by usersKey after introducing shared_preferences

  // Simulate network delay
  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Load all registered users from local storage
  Future<List<Map<String, String>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  // Save all users to local storage
  Future<void> _saveUsers(List<Map<String, String>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  // Save current logged in user
  Future<void> _saveCurrentUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user));
  }

  // Get current logged in user
  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_currentUserKey);
    if (jsonString == null) return null;
    return Map<String, String>.from(jsonDecode(jsonString));
  }

  // Remove current logged in user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
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
    final newUser = {
      'name': fullName,
      'email': email,
      'password': password,
    };

    users.add(newUser);
    await _saveUsers(users);
    await _saveCurrentUser(newUser);

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

    await _saveCurrentUser(Map<String, String>.from(user));

    return {'success': true, 'message': 'Login successful', 'user': user};
  }
}
