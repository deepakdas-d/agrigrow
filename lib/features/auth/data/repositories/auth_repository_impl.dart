import 'package:agrigrow/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> login(String username, String password) async {
    // Fake network delay
    await Future.delayed(const Duration(seconds: 1));
    // Always return true for fake auth
    return true;
  }

  @override
  Future<void> logout() async {
    // Fake network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
