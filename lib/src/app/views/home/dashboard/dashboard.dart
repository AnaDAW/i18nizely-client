import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_languages_chip.dart';
import 'package:i18nizely/src/app/common/app_list_card.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                    onSubmit: (value) {
                      final name = value.isNotEmpty ? value : null;
                      locator<ProjectListBloc>().add(GetProjects(page: 1, name: name));
                      locator<CollabProjectListBloc>().add(GetProjects(page: 1, name: name));
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
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      BlocBuilder<ProjectListBloc, ProjectListState>(
                        builder: (context, state) {
                          if (state is ProjectListInitial) {
                            locator<ProjectListBloc>().add(GetProjects(page: state.page));
                          }
                          return AppListCard(
                            title: 'My Projects',
                            emptyText: 'No projects created yet.',
                            state: state,
                            changePage: (page) => locator<ProjectListBloc>().add(GetProjects(page: page)),
                          );
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 70, right: 20),
                        child: AppIconButton(
                          icon: Icons.add,
                          onPressed: () => showCreateDialog(context, profile.language ?? 'en')),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: BlocBuilder<CollabProjectListBloc, ProjectListState>(
                    builder: (context, state) {
                      if (state is ProjectListInitial) {
                        locator<CollabProjectListBloc>().add(GetProjects(page: state.page));
                      }
                      return AppListCard(
                        title: 'Shared with me',
                        emptyText: 'No projects shared with me.',
                        state: state,
                        changePage: (page) => locator<CollabProjectListBloc>().add(GetProjects(page: page)),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void showCreateDialog(BuildContext context, String profileLang) {
    showDialog(
      context: context,
      builder: (context) {
        return _DashboardDialog(profileLang: profileLang,);
      },
    );
  }
}

class _DashboardDialog extends StatefulWidget {
  final String profileLang;
  
  const _DashboardDialog({required this.profileLang});
  
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
    mainLanguage = widget.profileLang;
    getLanguages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCardTitle(title: 'New Project'),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 20, right: 40, top: 20),
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
                  SizedBox(width: 50,),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Main Language', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        DropdownButton(
                          value: mainLanguage,
                          items: [
                            for (MapEntry<String, dynamic> entry in languages.entries)
                              DropdownMenuItem(value: entry.key, child: Text(entry.value as String))
                          ],
                          onChanged: (value) => setState(() => mainLanguage = value!),
                        ),
                        SizedBox(height: 30,),
                        AppLanguagesChip(availableLanguages: ['test', 'prueba'], onChanged: (value) => print('$value'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.detail,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: AppOutlinedButton(onPressed: () => context.pop(false), text: 'Cancel')),
                  SizedBox(width: 50,),
                  Expanded(child: AppStyledButton(onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    Project project = Project(
                      name: name,
                      description: null,
                      mainLanguage: mainLanguage,
                      languages: ['es', 'it']
                    );
                    locator<ProjectBloc>().add(CreateProject(project));
                    context.pop(true);
                  }, text: 'Create')),
                ],
              ),
            )
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