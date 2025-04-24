import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/src/app/router/app_router.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';

class AppDrawer extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback expand;
  final int selectedIndex;
  final void Function(int) getSelectedIndex;
  final User profile;
  final bool hasProject;

  const AppDrawer({required this.isExpanded, required this.expand, required this.selectedIndex, required this.getSelectedIndex, required this.profile, required this.hasProject, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? 210 : 80,
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
        alignment: selectedIndex == 0 ? Alignment.bottomLeft : Alignment.topLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.0 * selectedIndex, left: 10, bottom: 40),
            child: DrawerSelector(height: 120,),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
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
                    SizedBox(height: 20,),
                    buildDrawerButton(
                      context,
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      drawerRoute: DrawerRoute.dashboard
                    ),
                    if (hasProject)
                    Column(
                      children: [
                        buildDrawerButton(
                          context,
                          icon: Icons.edit_document,
                          label: 'Overview',
                          drawerRoute: DrawerRoute.overview
                        ),
                        buildDrawerButton(
                          context,
                          icon: Icons.translate_rounded,
                          label: 'Translations',
                          drawerRoute: DrawerRoute.translations
                        ),
                        buildDrawerButton(
                          context,
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          drawerRoute: DrawerRoute.settings
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Column(
                  children: [
                    buildAccountButton(context),
                    buildIconButton(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      onPressed: () async {
                        await locator<AuthApi>().logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({required IconData icon, required String label, bool isSelected = false, required VoidCallback onPressed}) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 60,
      child: IconButton(
        onPressed: onPressed,
        icon: Row(
          children: [
            Icon(icon, color: Colors.white),
            if (isExpanded)
              Row(
                children: [
                  SizedBox(width: 15,),
                  Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerButton(BuildContext context, {required IconData icon, required String label, required DrawerRoute drawerRoute}) {
    return buildIconButton(
      icon: icon,
      label: label,
      isSelected: selectedIndex == drawerRoute.index,
      onPressed: () {
        context.goNamed(drawerRoute.name);
        getSelectedIndex(drawerRoute.index);
      }
    );
  }

  Widget buildAccountButton(BuildContext context) {
    final bool isSelected = selectedIndex == DrawerRoute.account.index;
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 60,
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: AppUserIcon(image: profile.image, userName: '${profile.firstName?[0]}${profile.lastName?[0]}',)
              ),
              if (isExpanded)
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Account', style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),),
                        Text(
                          '${profile.firstName} ${profile.lastName}',
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.goNamed(DrawerRoute.account.name, extra: profile);
              getSelectedIndex(DrawerRoute.account.index);
            },
            icon: Container(),
          ),
        ],
      ),
    );
  }
}

class DrawerSelector extends StatelessWidget {
  final double height;

  const DrawerSelector({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DrawerSelectorClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: height,
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