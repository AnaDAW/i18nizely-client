import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_list_card.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

import '../../../common/app_languages_chip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User profile = context.select((ProfileBloc bloc) => (bloc.state as ProfileLoaded).profile);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(
          title: 'Dashboard',
          hasSearch: true,
          hint: 'Search a project...',
          onSumitSearch: (value) {
            locator<ProjectListBloc>().add(GetProjects(page: 1, name: value));
            locator<CollabProjectListBloc>().add(GetProjects(page: 1, name: value));
          },
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
                            deleteProject: (id) {
                              locator<ProjectListBloc>().add(DeleteProjectFromList(id));
                              locator<ProjectBloc>().add(DeleteProject(id, refresh: true));
                            },
                          );
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, right: 20),
                        child: AppIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => _DashboardDialog(profileLang: profile.language ?? 'en'),
                            );
                          },
                        ),
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
                        deleteProject: (id) {
                          locator<CollabProjectListBloc>().add(DeleteProjectFromList(id));
                        },
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
}

class _DashboardDialog extends StatefulWidget {
  final String profileLang;
  
  const _DashboardDialog({required this.profileLang});
  
  @override
  State<_DashboardDialog> createState() => _DashboardDialogState();
}

class _DashboardDialogState extends State<_DashboardDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> languages;
  late String mainLanguage;
  late String name;
  late String? description;
  List<String> selectedLang = [];

  @override
  void initState() {
    mainLanguage = widget.profileLang;
    languages = AppConfig.languages;
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
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                description = value;
                              } else {
                                description = null;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 50,),
                  Expanded(
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
                        AppLanguagesChip(
                          mainLanguage: mainLanguage,
                          languages: languages,
                          onChange: (value) => selectedLang = value,
                        ),
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
                  Expanded(child: AppOutlinedButton(onPressed: () => context.pop(), text: 'Cancel')),
                  SizedBox(width: 50,),
                  Expanded(child: AppStyledButton(text: 'Create', onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await createProject();
                    context.pop();
                  })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> createProject() async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectBloc>().stream.listen((state) {
      if (state is ProjectLoaded) {
        subscription.cancel();
        locator<ProjectListBloc>().add(CreateProjectFromList());
        locator<TranslationsBloc>().add(GetTranslations(projectId: state.project.id ?? 0, page: 1));
        completer.complete();
      } else if (state is ProjectError) {
        subscription.cancel();
        completer.completeError(state.message);
      }
    });

    Project project = Project(
        name: name,
        description: description,
        mainLanguage: mainLanguage,
        languages: selectedLang
    );

    locator<ProjectBloc>().add(CreateProject(project));
    return completer.future;
  }
}