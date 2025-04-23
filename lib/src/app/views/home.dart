import 'package:flutter/material.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';
import 'package:i18nizely/src/domain/service/user_api.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  
  const HomeScreen({required this.child, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? profile;
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
          AppDrawer(isExpanded: isDrawerExpanded, expand: expandDrawer, selectedIndex: selectedIndex, getSelectedIndex: getSelectedIndex),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getProfile() async {
    final res = await locator<UserApi>().getProfile();
    res.fold((left) => print(left), (right) => setState(() => profile = right));
  }

  void expandDrawer() => setState(() => isDrawerExpanded = !isDrawerExpanded);

  void getSelectedIndex(int index) => setState(() => selectedIndex = index);
}