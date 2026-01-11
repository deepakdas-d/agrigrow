import 'package:flutter/material.dart';
import 'package:agrigrow/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  AuthProvider(this._authRepository);

  Future<void> login(String username, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final success = await _authRepository.login(username, password);
      if (success) {
        _status = AuthStatus.authenticated;
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
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
