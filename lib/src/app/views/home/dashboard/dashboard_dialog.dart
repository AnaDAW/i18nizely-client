import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_languages_chip.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class DashboardDialog extends StatefulWidget {
  final String profileLang;
  
  const DashboardDialog({super.key, required this.profileLang});
  
  @override
  State<DashboardDialog> createState() => _DashboardDialogState();
}

class _DashboardDialogState extends State<DashboardDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> languages = AppConfig.languages;
  late String mainLanguage;
  late String name;
  late String? description;
  List<String> selectedLang = [];
  String? languagesError;

  @override
  void initState() {
    mainLanguage = widget.profileLang;
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
                          error: languagesError,
                          selected: selectedLang,
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
                      await createProject();
                      context.pop();
                    } catch (e) {
                      setState(() => languagesError = (e as dynamic)['languages']?[0]);
                    }
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

    subscription = locator<ProjectListBloc>().stream.listen((state) {
      if (state is ProjectCreated) {
        subscription.cancel();
        locator<ProjectBloc>().add(GetProject(state.projectId));
        locator<TranslationsBloc>().add(GetTranslations(projectId: state.projectId, page: 1));
        completer.complete();
      } else if (state is ProjectCreateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    Project project = Project(
      name: name,
      description: description,
      mainLanguage: mainLanguage,
      languages: selectedLang
    );

    locator<ProjectListBloc>().add(CreateProject(project));
    return completer.future;
  }
}