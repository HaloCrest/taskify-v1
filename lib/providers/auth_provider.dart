import 'package:flutter/material.dart';
import 'package:taskify/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Dummy login logic - in a real app, this would call an API
    if (email == 'user@example.com' && password == 'password') {
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
        photoUrl: 'https://i.pravatar.cc/150?img=8',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Dummy signup logic - in a real app, this would call an API
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      photoUrl: 'https://i.pravatar.cc/150?img=8',
    );
    
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
