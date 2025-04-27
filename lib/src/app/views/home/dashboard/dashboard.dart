import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_list_card.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

import '../../../../../shared/theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Project>? ownProjects;
  List<Project>? collabProjects;
  String? searchName;
  int ownPage = 1;
  int ownTotalPages = 1;
  int collabPage = 10;
  int collabTotalPages = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User profile = context.select((ProfileBloc bloc) => (bloc.state as ProfileLoaded).profile);

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
                  child: AppSearchTextField(
                    hint: 'Search a project...',
                    onSubmit: (value) async {
                      searchName = value.isNotEmpty ? value : null;
                      await updateOwnProjects(1);
                      await updateCollabProjects(1);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: FutureBuilder(
              future: getProjects(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error.toString());
                  }
                  return Center(
                    child: Text('Unknown error occurred.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return _DashboardBody(
                    ownProjects: ownProjects!,
                    collabProjects: collabProjects!,
                    getOwnProjects: updateOwnProjects,
                    getCollabProjects: updateCollabProjects,
                    ownPage: ownPage,
                    ownTotalPages: ownTotalPages,
                    collabPage: collabPage,
                    collabTotalPages: collabTotalPages,
                    profile: profile,
                  );
                }
                return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
              }
            ),
          ),
        )
      ],
    );
  }

  Future<void> getProjects() async {
    if (ownProjects != null && collabProjects != null) return;

    ownProjects = await getOwnProjects(1);
    collabProjects = await getCollabProjects(1);
  }

  Future<void> updateOwnProjects(int page) async {
    await getOwnProjects(page).then((projects) {
      setState(() {
        ownProjects = projects;
        ownPage = page;
      });
    });
  }

  Future<List<Project>?> getOwnProjects(int page) async {
    final res = await locator<ProjectApi>().getProjects(name: searchName, page: page);
    return res.fold((left) async {
        final refresh = await locator<AuthApi>().refresh();
        return refresh.fold(
          (l) async {
            await locator<AuthApi>().logout();
            context.go('/login');
            return null;
          }, (r) => getOwnProjects(page)
        );
      }, (right) => right
    );
  }

  Future<void> updateCollabProjects(int page) async {
    await getCollabProjects(page).then((projects) {
      setState(() {
        collabProjects = projects;
        collabPage = page;
      });
    });
  }

  Future<List<Project>?> getCollabProjects(page) async {
    final res = await locator<ProjectApi>().getCollabProjects(name: searchName, page: page,);
    return res.fold((left) async {
        final refresh = await locator<AuthApi>().refresh();
        return refresh.fold(
          (l) async {
            await locator<AuthApi>().logout();
            context.go('/login');
            return null;
          }, (r) => getCollabProjects(page)
        );
      }, (right) => right
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final List<Project> ownProjects;
  final List<Project> collabProjects;
  final Future<void> Function(int) getOwnProjects;
  final Future<void> Function(int) getCollabProjects;
  final int ownPage;
  final int ownTotalPages;
  final int collabPage;
  final int collabTotalPages;
  final User profile;

  const _DashboardBody({
    required this.ownProjects, required this.collabProjects, required this.getOwnProjects,required this.getCollabProjects,
    required this.ownPage, required this.ownTotalPages, required this.collabPage, required this.collabTotalPages, required this.profile
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppListCard(
                projects: ownProjects,
                title: 'My Projects',
                emptyText: 'No projects created yet.',
                actualPage: ownPage,
                totalPages: ownTotalPages,
                changePage: getOwnProjects,
              ),
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
          child: AppListCard(
            projects: collabProjects,
            title: 'Shared with me',
            emptyText: 'No projects shared with me.',
            actualPage: collabPage,
            totalPages: collabTotalPages,
            changePage: getCollabProjects,
          ),
        )
      ],
    );
  }

  void showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _DashboardDialog(profile: profile,);
      },
    );
  }
}

class _DashboardDialog extends StatefulWidget {
  final User profile;
  
  const _DashboardDialog({required this.profile});
  
  @override
  State<_DashboardDialog> createState() => _DashboardDialogState();
}

class _DashboardDialogState extends State<_DashboardDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> languages = {};
  late String mainLanguage;
  late String name;
  final List<String> selectedLang = [];

  @override
  void initState() {
    mainLanguage = widget.profile.language ?? 'en';
    getLanguages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          children: [
            AppCardTitle(title: 'New Project'),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 40, right: 40, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppOutlinedTextField(
                            label: 'Project Name',
                            hint: 'Type the project name here.',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'The project name can\'t be empty.';
                              name = value;
                              return null;
                            },
                          ),
                          SizedBox(height: 30,),
                          AppOutlinedTextField(
                            label: 'Project Description',
                            hint: 'Type the project description here. (optional)',
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Main Language', style: TextStyle(fontWeight: FontWeight.bold),),
                        DropdownButton(
                          value: mainLanguage,
                          items: [
                            for (MapEntry<String, dynamic> entry in languages.entries)
                              DropdownMenuItem(value: entry.key, child: Text(entry.value as String))
                          ],
                          onChanged: (value) => setState(() => mainLanguage = value!),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getLanguages() async {
    String json = await DefaultAssetBundle.of(context).loadString('assets/languages.json');
    setState(() => languages = jsonDecode(json));
  }
}