import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/common/app_pages_bar.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';

class TranslationsScreen extends StatelessWidget {
  const TranslationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Project project = context.select((ProjectBloc bloc) => (bloc.state as ProjectLoaded).project);
    final Map<String, dynamic> languages = AppConfig.languages;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(
          title: 'Translations',
          hasSearch: true,
          hint: 'Search a key...',
          onSumitSearch: (_) {},
        ),
        Expanded(
          child: BlocConsumer<TranslationsBloc, TranslationsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: state is TranslationsLoading ? Center(
                              child: CircularProgressIndicator(color: AppColors.detail,),
                            ) : state is TranslationsLoaded ? Stack(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 75,
                                              child: Checkbox(value: false, onChanged: (_) {}),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                'Keys',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            for (String lang in project.languages!)
                                              SizedBox(
                                                width: 300,
                                                child: Text(
                                                  languages[lang] ?? '',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              for (TransKey key in state.keys)
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 75,
                                                      child: Checkbox(value: false, onChanged: (_) {}),
                                                    ),
                                                    Container(
                                                      height: 200,
                                                      width: 300,
                                                      padding: EdgeInsets.all(10),
                                                      child: AppElevatedCard(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(key.name.toString(),),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded)),
                                                                  IconButton(onPressed: () {}, icon: Icon(Icons.check_rounded)),
                                                                  IconButton(onPressed: () {}, icon: Icon(Icons.delete_rounded)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    for (String lang in project.languages!)
                                                      buildTranslationCard(lang, key.translations!),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.keys.isEmpty)
                                  Center(
                                    child: Text(
                                      'There are no translations yet.',
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  )
                              ],
                            ) : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_rounded, color: Colors.red.shade400,),
                                SizedBox(width: 5,),
                                Text(
                                  'Error getting the translations.',
                                  style: TextStyle(color: Colors.red.shade400),
                                ),
                              ],
                            ),
                          )
                        ),
                        AppPagesBar(
                          page: state.page,
                          totalPages: state.totalPages,
                          changePage: (page) => locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: page)),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, right: 20),
                    child: AppIconButton(
                      icon: Icons.add,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _TranslationsDialog(projectId: project.id ?? 0),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }

  Widget buildTranslationCard(String lang, List<Translation> translations) {
    String text = '';

    for (Translation translation in translations) {
      if (translation.language == lang) {
        text = translation.text.toString();
      }
    }

    return Container(
      height: 200,
      width: 300,
      padding: EdgeInsets.all(10),
      child: AppElevatedCard(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(text,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.check_rounded)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.comment_rounded)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.restore_rounded)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TranslationsDialog extends StatefulWidget {
  final int projectId;
  
  const _TranslationsDialog({required this.projectId});
  
  @override
  State<_TranslationsDialog> createState() => _TranslationsDialogState();
}

class _TranslationsDialogState extends State<_TranslationsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String? description;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCardTitle(title: 'New Key'),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 20, right: 40, top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppOutlinedTextField(
                      label: 'Key Name',
                      hint: 'Type the key name here (no spaces).',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'The project name can\'t be empty.';
                        name = value;
                        return null;
                      },
                    ),
                    SizedBox(height: 30,),
                    AppOutlinedTextField(
                      label: 'Key Description',
                      hint: 'Type the key description here. (optional)',
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
        
                    TransKey key = TransKey(
                      name: name,
                      description: description,
                    );
                    locator<TranslationsBloc>().add(CreateKey(projectId: widget.projectId, newKey: key));
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
}