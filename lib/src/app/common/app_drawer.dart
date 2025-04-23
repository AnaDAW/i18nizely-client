import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';

class AppDrawer extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback expand;
  final int selectedIndex;
  final void Function(int) getSelectedIndex;

  const AppDrawer({required this.isExpanded, required this.expand, required this.selectedIndex, required this.getSelectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ]
        ),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20),)
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.0 * selectedIndex, left: 10, bottom: 40),
            child: DrawerSelector(height: 120, width: isExpanded ? 200 : 70,),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: isExpanded ? 170 : 40,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: expand,
                            icon: Icon(isExpanded ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: AppColors.detail,),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    buildDrawerButton(
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      isSelected: selectedIndex == 1,
                      onPressed: () {
                        context.pushReplacement('/dashboard');
                        getSelectedIndex(1);
                      },
                    ),
                    buildDrawerButton(
                      icon: Icons.edit_document,
                      label: 'Overview',
                      isSelected: selectedIndex == 2,
                      onPressed: () {
                        context.pushReplacement('/overview');
                        getSelectedIndex(2);
                      },
                    ),
                    buildDrawerButton(
                      icon: Icons.translate_rounded,
                      label: 'Translations',
                      isSelected: selectedIndex == 3,
                      onPressed: () {
                        context.pushReplacement('/translations');
                        getSelectedIndex(3);
                      },
                    ),
                    buildDrawerButton(
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      isSelected: selectedIndex == 4,
                      onPressed: () {
                        context.pushReplacement('/settings');
                        getSelectedIndex(4);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                buildDrawerButton(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  isSelected: false,
                  onPressed: () async {
                    await locator<AuthApi>().logout();
                    context.pushReplacement('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerButton({required IconData icon, required String label, required bool isSelected, required VoidCallback onPressed}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 60,
      child: IconButton(
        onPressed: onPressed,
        icon: isExpanded ? Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 15,),
            Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),),
          ],
        ) : Icon(icon, color: Colors.white),
      ),
    );
  }
}

class DrawerSelector extends StatelessWidget {
  final double height;
  final double width;

  const DrawerSelector({required this.height, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DrawerSelectorClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: height,
        width: width,
        color: Colors.white,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: (height / 2) - 20,
            width: (height / 2) - 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.secondary
                ]
              ),
              borderRadius: BorderRadius.circular(height / 4)
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerSelectorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.height / 4;

    path.moveTo(size.width, 0);
    path.arcToPoint(
      Offset(size.width - radius, radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(radius, radius);
    path.arcToPoint(
      Offset(radius, size.height - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width - radius, size.height - radius);
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(radius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}