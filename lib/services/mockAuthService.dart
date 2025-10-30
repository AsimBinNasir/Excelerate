import 'dart:async';

class MockAuthService {
  // Simulated in-memory user db
  final List<Map<String, String>> _users = [];

  // Simulate network delay
  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Sign up a new user
  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _simulatedNetworkDelay();

    // Check if email already exists
    final existingUser = _users.any((user) => user['email'] == email);
    if (existingUser) {
      return {'success': false, 'message': 'Email already registered'};
    }

    // Add user to mock database
    _users.add({'name': fullName, 'email': email, 'password': password});

    return {'success': true, 'message': 'Account created successfully'};
  }

  // Sign in user
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    await _simulatedNetworkDelay();

    // Looking for matching user
    final user = _users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      return {'success': false, 'message': 'Invalid email or password'};
    }

    return {'success': true, 'message': 'Login successful', 'user': user};
  }
}
