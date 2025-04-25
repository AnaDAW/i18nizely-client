import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final User profile;
  List<Project> ownProjects = [];
  List<Project> sharedProjects = [];

  @override
  void initState() {
    getProfile();
    getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10,),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
              ),
              Center(
                child: SizedBox(
                  width: 500,
                  child: AppSearchTextField(hint: 'Search a project...'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: _DashboardBody(ownProjects: ownProjects, sharedProjects: sharedProjects),
          ),
        )
      ],
    );
  }

  void getProfile() => profile = HomeScreen.getProfile(context) ?? User();

  Future<void> getProjects() async {
    final List<Project> own = [];
    final List<Project> shared = [];

    final res = await locator<ProjectApi>().getProjects();
    res.fold(
      (left) async {
        final refresh = await locator<AuthApi>().refresh();
        refresh.fold(
          (l) async {
            await locator<AuthApi>().logout();
            context.go('/login');
          }, (r) => getProjects()
        );
      }, (right) {
        own.addAll(right);
      }
    );

    for (Project project in own) {
      if (project.createdBy?.id != profile.id) {
        shared.add(project);
        own.remove(project);
      }
    }

    setState(() {
      ownProjects = own;
      sharedProjects = shared;
    });
  }
}

class _DashboardBody extends StatelessWidget {
  final List<Project> ownProjects;
  final List<Project> sharedProjects;

  const _DashboardBody({required this.ownProjects, required this.sharedProjects});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              buildDashboardCard(projects: ownProjects, title: 'My Projects', emptyText: 'No projects created yet.',),
              Padding(
                padding: const EdgeInsets.only(bottom: 70, right: 20),
                child: AppIconButton(
                  icon: Icons.add,
                  onPressed: () => showCreateDialog(context)),
              ),
            ],
          ),
        ),
        SizedBox(width: 50,),
        Expanded(
          child: buildDashboardCard(projects: sharedProjects, title: 'Shared with me', emptyText: 'No projects shared with me.'),
        )
      ],
    );
  }

  void showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppOutlinedTextField(label: 'Project Name', hint: 'Type the project name here.'),
              SizedBox(height: 30,),
              AppOutlinedTextField(label: 'Project Description', hint: 'Type the project description here.'),
            ],
          ),
        );
      },
    );
  }

  Widget buildDashboardCard({required List<Project> projects, required String title, required String emptyText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10,),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ]
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
            ),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: projects.isEmpty ? Center(
              child: Text(
                emptyText,
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            ) : SingleChildScrollView(),
          ),
          Divider(color: AppColors.detail, indent: 10, endIndent: 10,),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIconButton(icon: Icons.skip_previous_rounded, onPressed: () {}),
                buildIconButton(icon: Icons.navigate_before_rounded, onPressed: () {}),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('1 of 1', style: TextStyle(color: Colors.black45),),
                ),
                buildIconButton(icon: Icons.navigate_next_rounded, onPressed: () {}),
                buildIconButton(icon: Icons.skip_next_rounded, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black45,),
    );
  }
}