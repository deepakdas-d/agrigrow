import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrigrow/core/theme/app_theme.dart';
import 'package:agrigrow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:agrigrow/features/auth/domain/repositories/auth_repository.dart';
import 'package:agrigrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:agrigrow/features/auth/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:agrigrow/core/utils/location_service.dart';
import 'package:agrigrow/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:agrigrow/features/weather/domain/repositories/weather_repository.dart';
import 'package:agrigrow/features/weather/presentation/providers/weather_provider.dart';
import 'package:agrigrow/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:agrigrow/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<WeatherRepository>(create: (_) => WeatherRepositoryImpl(Dio())),
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            context.read<WeatherRepository>(),
            context.read<LocationService>(),
          ),
        ),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriGrow',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      // Retain routes if needed, but for now we rely on Wrapper for Auth status
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        switch (auth.status) {
          case AuthStatus.authenticated:
            return const DashboardPage();
          case AuthStatus.unauthenticated:
          default:
            return const LoginPage();
        }
      },
    );
  }
}
