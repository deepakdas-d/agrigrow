import 'package:flutter/material.dart';
import 'package:agrigrow/features/auth/domain/repositories/auth_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  AuthProvider(this._authRepository);

  Future<void> checkLoginStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final success = await _authRepository.login(username, password);
      if (success) {
        _status = AuthStatus.authenticated;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await _authRepository.logout();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
