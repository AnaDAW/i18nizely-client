import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/src/app/views/account.dart';
import 'package:i18nizely/src/app/views/dashboard.dart';
import 'package:i18nizely/src/app/views/home.dart';
import 'package:i18nizely/src/app/views/login.dart';
import 'package:i18nizely/src/app/views/overview.dart';
import 'package:i18nizely/src/app/views/settings.dart';
import 'package:i18nizely/src/app/views/translations.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';

enum DrawerRoute { account, dashboard, overview, translations, settings }

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final bool isLogged = await locator<AuthApi>().isLogged();
    final bool isLoginScreen = state.uri.toString() == '/login';
    try {
      if (isLoginScreen && isLogged) {
        return '/';
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
          name: DrawerRoute.account.name,
          path: '/${DrawerRoute.account.name}',
          builder: (context, state) => AccountScreen(),
        ),
        GoRoute(
          name: DrawerRoute.dashboard.name,
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          name: DrawerRoute.overview.name,
          path: '/${DrawerRoute.overview.name}',
          builder: (context, state) => const OverviewScreen(),
        ),
        GoRoute(
          name: DrawerRoute.translations.name,
          path: '/${DrawerRoute.translations.name}',
          builder: (context, state) => const TranslationsScreen(),
        ),
        GoRoute(
          name: DrawerRoute.settings.name,
          path: '/${DrawerRoute.settings.name}',
          builder: (context, state) => const SettingsScreen(),
        ),
      ]
    )
  ]
);