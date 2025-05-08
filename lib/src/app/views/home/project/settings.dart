import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_collaborators_list.dart';
import 'package:i18nizely/src/app/common/app_languages_chip.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(title: ' Project Settings'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(70),
            child: BlocConsumer<ProjectBloc, ProjectState>(
              listener: (context, state) {
                if (state is ProjectUpdated) {
                  AppSnackBar.showSnackBar(context, text: 'Project updated');
                } else if (state is CollaboratorAdded) {
                  AppSnackBar.showSnackBar(context, text: 'Collaborator added');
                } else if (state is CollaboratorUpdated) {
                  AppSnackBar.showSnackBar(context, text: 'Collaborator updated');
                } else if (state is CollaboratorRemoved) {
                  AppSnackBar.showSnackBar(context, text: 'Collaborator removed');
                }
              },
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
                } else if (state is ProjectError) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_rounded, color: Colors.red.shade400,),
                        SizedBox(width: 5,),
                        Text(
                          'Error getting the project.',
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProjectLoaded) {
                  return _SettingsForm(project: state.project);
                }
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_rounded, color: Colors.red.shade400,),
                      SizedBox(width: 5,),
                      Text(
                        'Project not found.',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsForm extends StatefulWidget {
  final Project project;

  const _SettingsForm({required this.project});

  @override
  State<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<_SettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> languages = AppConfig.languages;
  late String mainLanguage;
  late String name;
  late String? description;
  late List<String> selectedLang;
  String? languagesError;

  @override
  void initState() {
    mainLanguage = widget.project.mainLanguage ?? 'en';
    name = widget.project.name ?? '';
    description = widget.project.description;
    selectedLang = List.of(widget.project.languages ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppOutlinedTextField(
                              label: 'Project Name',
                              initialValue: name,
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
                              initialValue: description,
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
                              for (String lang in [mainLanguage, ...selectedLang])
                                DropdownMenuItem(value: lang, child: Text(languages[lang] as String))
                            ],
                            onChanged: (value) {
                              if (value == mainLanguage) return;
                              setState(() {
                                selectedLang.remove(value);
                                selectedLang.add(mainLanguage);
                                mainLanguage = value!;
                              });
                            },
                          ),
                          SizedBox(height: 30,),
                          AppLanguagesChip(
                            mainLanguage: mainLanguage,
                            languages: languages,
                            error: languagesError,
                            selected: selectedLang,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Divider(color: AppColors.detail,),
                SizedBox(height: 20,),
                AppCollaboratorsList(createdBy: widget.project.createdBy ?? User(), collaborators: widget.project.collaborators ?? [],),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.detail,),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: AppUserIcon(
                    image: widget.project.createdBy?.image,
                    userName: widget.project.createdBy?.initials ?? '',
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfo('Created by: ${widget.project.createdBy?.name ?? 'Unknown User'}'),
                    buildInfo('Created at: ${widget.project.createdAt?.toFormatStringDate(context) ?? 'Unknown Date'}'),
                    buildInfo('Last update: ${widget.project.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date'}'),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 200,
              child: AppStyledButton(
                text: 'Save',
                onPressed: () async {
                  bool isValida = true;
                  if (selectedLang.isEmpty) {
                    setState(() => languagesError = 'This list may not be empty.');
                    isValida = false;
                  }
                  if (!_formKey.currentState!.validate()) {
                    isValida = false;
                  }
                  if (!isValida) return;

                  try {
                    await updateProject();
                  } catch (e) {
                    setState(() => languagesError = (e as dynamic)['languages']?[0]);
                    AppSnackBar.showSnackBar(context, text: 'Error updating the project', isError: true);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildInfo(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black45,
        fontSize: 12,
      ),
    );
  }

  Project getUpdatedProject() {
    List<String> actualLang = widget.project.languages ?? [];
    List<String> languages = [];

    if (actualLang.length != selectedLang.length || selectedLang.any((lang) => !actualLang.contains(lang))) {
      languages.addAll(selectedLang);
    }

    return Project(
      id: widget.project.id ?? 0,
      name: widget.project.name != name ? name : null,
      description: widget.project.description != description ? description : null,
      mainLanguage: widget.project.mainLanguage != mainLanguage ? mainLanguage : null,
      languages: languages.isNotEmpty ? languages : null,
    );
  }

  Future<void> updateProject() async {
    final Project project = getUpdatedProject();
    if (project == Project(id: widget.project.id ?? 0)) return;

    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectBloc>().stream.listen((state) {
      if (state is ProjectUpdated) {
        subscription.cancel();
        locator<ProjectListBloc>().add(UpdateProjectList(widget.project.id ?? 0));
        completer.complete();
      } else if (state is ProjectUpdateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<ProjectBloc>().add(UpdateProject(project));
    return completer.future;
  }
}