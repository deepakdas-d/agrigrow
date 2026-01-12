import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrigrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:agrigrow/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // Start auth check
    final authProvider = context.read<AuthProvider>();
    // We don't await the check here, we let it happen in background 
    // so it updates the provider state.
    authProvider.checkLoginStatus();

    // Enforce splash duration
    await Future.delayed(const Duration(milliseconds: 1600));

    if (!mounted) return;

    // Navigate to AuthWrapper which handles the rest
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... existing build ...
    return Scaffold(
      backgroundColor: const Color(0xFF426F4C),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset('assets/images/argo-grow.png', width: 140),
          ),
        ),
      ),
    );
  }
}
