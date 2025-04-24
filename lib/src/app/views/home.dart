import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/model/project_model.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';
import 'package:i18nizely/src/domain/service/user_api.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  
  const HomeScreen({required this.child, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User profile = User();
  Project ? selectedProject;
  bool isDrawerExpanded = false;
  int selectedIndex = 1;

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Row(
        children: [
          AppDrawer(
            isExpanded: isDrawerExpanded,
            expand: expandDrawer,
            selectedIndex: selectedIndex,
            getSelectedIndex: getSelectedIndex,
            profile: profile,
            hasProject: selectedProject != null,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: widget.child,
            ),
          ),
        ],
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

  void getSelectedIndex(int index) => setState(() => selectedIndex = index);

  void getSelectedProject(Project project) {
    setState(() {
      selectedIndex = 2;
      selectedProject = project;
    });
  }
}