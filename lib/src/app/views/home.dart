import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  
  const HomeScreen({required this.child, super.key});

  static void setProfile(BuildContext context, User profile) {
    _HomeScreenState? state = context.findAncestorStateOfType<_HomeScreenState>();
    state?.updateProfile(profile);
  }

  static User? getProfile(BuildContext context) {
    _HomeScreenState? state = context.findAncestorStateOfType<_HomeScreenState>();
    return state?.profile;
  }

  static void selectProject(BuildContext context, int id) {
    _HomeScreenState? state = context.findAncestorStateOfType<_HomeScreenState>();
    state?.selectProject(id);
  }

  static void selectIndex(BuildContext context, int index) {
    _HomeScreenState? state = context.findAncestorStateOfType<_HomeScreenState>();
    state?.changeSelectedIndex(index);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User profile = User();
  int? selectedProject;
  bool isDrawerExpanded = false;
  int selectedIndex = 1;

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            AppDrawer(
              isExpanded: isDrawerExpanded,
              expand: expandDrawer,
              selectedIndex: selectedIndex,
              hasProject: selectedProject != null,
            ),
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getProfile() async {
    final user = await locator<UserApi>().getProfile();
    user.fold(
      (left) async {
        final refresh = await locator<AuthApi>().refresh();
        refresh.fold(
          (l) async {
            await locator<AuthApi>().logout();
            context.go('/login');
          }, (r) => getProfile()
        );
      }, (right) {
        setState(() => profile = right);
      }
    );
  }

  void expandDrawer() => setState(() => isDrawerExpanded = !isDrawerExpanded);

  void changeSelectedIndex(int index) => setState(() => selectedIndex = index);

  void updateProfile(User newProfile) => setState(() => profile = newProfile);

  void selectProject(int id) => setState(() => selectedProject = id);
}