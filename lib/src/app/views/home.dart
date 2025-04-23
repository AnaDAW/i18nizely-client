import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';
import 'package:i18nizely/src/domain/service/user_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? profile;
  bool isDrawerExpanded = false;

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
          AppDrawer(isExpanded: isDrawerExpanded, cahngeExpanded: cahngeExpanded,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dashboard'),
                      SizedBox(
                        width: 600,
                        child: AppSearchTextField(hint: 'Search something'),
                        ),
                      Text(profile?.firstName ?? ''),
                    ],
                  ),
                ],
              ),
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

  void cahngeExpanded() {
    setState(() => isDrawerExpanded = !isDrawerExpanded);
  }
}