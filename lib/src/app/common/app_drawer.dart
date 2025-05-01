import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/src/app/router/app_router.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';

class AppDrawer extends StatefulWidget {
  final User profile;

  const AppDrawer({super.key, required this.profile});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isExpanded = false;
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? 210 : 80,
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20),)
      ),
      child: Stack(
        alignment: selectedIndex == DrawerRoute.account.index ?
          Alignment.bottomLeft : Alignment.topLeft,
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
                          onPressed: () => setState(() => isExpanded = !isExpanded),
                          icon: Icon(isExpanded ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: AppColors.detail,),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    buildDrawerButton(
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      drawerRoute: DrawerRoute.dashboard
                    ),
                    BlocConsumer<ProjectBloc, ProjectState>(
                      listenWhen: (previous, current) => (previous is ProjectInitial && current is! ProjectInitial) || current is ProjectDeleted,
                      listener: (context, state) {
                        late final DrawerRoute drawerRoute;
                        if (state is ProjectDeleted) {
                          drawerRoute = DrawerRoute.dashboard;
                        } else {
                          drawerRoute = DrawerRoute.overview;
                        }
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          context.goNamed(drawerRoute.name);
                          setState(() => selectedIndex = drawerRoute.index);
                        });
                      },
                      buildWhen: (previous, current) {
                        return (previous is ProjectInitial && current is! ProjectInitial) || (previous is! ProjectInitial && current is ProjectInitial);
                      },
                      builder: (context, state) {
                        late final bool isProjectSelected;
                        if (state is ProjectInitial) {
                          isProjectSelected = false;
                        } else {
                          isProjectSelected = true;
                        }

                        return Column(
                          children: [
                            buildDrawerButton(
                              icon: Icons.edit_document,
                              label: 'Overview',
                              drawerRoute: DrawerRoute.overview,
                              enabled: isProjectSelected
                            ),
                            buildDrawerButton(
                              icon: Icons.translate_rounded,
                              label: 'Translations',
                              drawerRoute: DrawerRoute.translations,
                              enabled: isProjectSelected
                            ),
                            buildDrawerButton(
                              icon: Icons.settings_rounded,
                              label: 'Settings',
                              drawerRoute: DrawerRoute.settings,
                              enabled: isProjectSelected
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Column(
                  children: [
                    buildAccountButton(),
                    AppDrawerIcon(
                      isExpanded: isExpanded,
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

  Widget buildDrawerButton({required IconData icon, required String label, required DrawerRoute drawerRoute, bool enabled = true}) {
    return AppDrawerIcon(
      isExpanded: isExpanded,
      icon: icon,
      label: label,
      isSelected: selectedIndex == drawerRoute.index,
      onPressed: () {
        context.goNamed(drawerRoute.name);
        setState(() => selectedIndex = drawerRoute.index);
      },
      enabled: enabled
    );
  }

  Widget buildAccountButton() {
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
                child: AppUserIcon(image: widget.profile.image, userName: '${widget.profile.firstName?[0]}${widget.profile.lastName?[0]}',)
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
                          '${widget.profile.firstName} ${widget.profile.lastName}',
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
              context.goNamed(DrawerRoute.account.name);
              setState(() => selectedIndex = DrawerRoute.account.index);
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
              gradient: AppColors.gradient,
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