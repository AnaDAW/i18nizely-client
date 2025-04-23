import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/src/app/views/dashboard.dart';
import 'package:i18nizely/src/app/views/home.dart';
import 'package:i18nizely/src/app/views/login.dart';
import 'package:i18nizely/src/app/views/overview.dart';
import 'package:i18nizely/src/app/views/settings.dart';
import 'package:i18nizely/src/app/views/translations.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final bool isLogged = await locator<AuthApi>().isLogged();
    final bool isLoginScreen = state.uri.toString() == '/login';
    try {
      if (isLoginScreen && isLogged) {
        return '/dashboard';
      }

      if (!isLoginScreen && !isLogged) {
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
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          name: 'dashboard',
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          name: 'overview',
          path: '/overview',
          builder: (context, state) => const OverviewScreen(),
        ),
        GoRoute(
          name: 'translations',
          path: '/translations',
          builder: (context, state) => const TranslationsScreen(),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ]
    )
  ]
);