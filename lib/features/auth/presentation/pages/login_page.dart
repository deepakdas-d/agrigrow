import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Provider.of<AuthProvider>(context, listen: false).login(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background decorations (Circles)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/argo-grow.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                            Icons.eco,
                            size: 60,
                            color: Colors.white,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Email/Username Field
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email or Username',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.darkGreen),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.darkGreen),
                      suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.darkGreen),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        if (auth.status == AuthStatus.loading) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                        }
                        return ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('SIGN IN'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
