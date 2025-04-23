import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/src/app/views/home.dart';
import 'package:i18nizely/src/app/views/login.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    try {
      if (!await locator<AuthApi>().isLogged()) {
        return '/login';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during authentication check: $e');
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomeScreen(),
    )
  ]
);