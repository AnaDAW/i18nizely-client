import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_pages_bar.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/app/views/home/translations/translations_create_dialog.dart';
import 'package:i18nizely/src/app/views/home/translations/translations_dialog.dart';
import 'package:i18nizely/src/app/views/home/translations/translations_edit_dialog.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';

class TranslationsScreen extends StatelessWidget {

  const TranslationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Project project = context.select((ProjectBloc bloc) {
      if (bloc.state is ProjectLoaded) {
        return (bloc.state as ProjectLoaded).project;
      }
      return Project();
    });
    String? name;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(
          title: 'Translations',
          hasSearch: true,
          hint: 'Search a key...',
          onSumitSearch: (value) {
            if (value != null && value.isNotEmpty) {
              name = value;
            } else {
              name = null;
            }
            locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: 1, name: name));
          },
        ),
        Expanded(
          child: _TranslationsBody(project: project),
        ),
      ],
    );
  }
}

class _TranslationsBody extends StatefulWidget {
  final Project project;

  const _TranslationsBody({required this.project});
  
  @override
  State<_TranslationsBody> createState() => _TranslationsBodyState();
}

class _TranslationsBodyState extends State<_TranslationsBody> {
  final Map<String, dynamic> languages = AppConfig.languages;
  late final List<String> projectLang;
  final List<String> filteredLang = [];
  String? name;
  bool showFilters = false;
  final List<int> selectedKeys = [];

  @override
  void initState() {
    projectLang = [widget.project.mainLanguage ?? ''];
    projectLang.addAll(widget.project.languages ?? []);
    filteredLang.addAll(projectLang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranslationsBloc, TranslationsState>(
      listener: (context, state) {
        print(state);
        if (state is KeyCreated) {
          AppSnackBar.showSnackBar(context, text: 'Key created');
        } else if (state is KeyCreateError) {
          AppSnackBar.showSnackBar(context, text: 'Error creating key', isError: true);
        }
      },
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
                          _TranslationsTable(
                            languages: languages,
                            filteredLang: filteredLang,
                            keys: state.keys,
                            selectedKeys: selectedKeys,
                            selectKey: (value, id) {
                              setState(() {
                                if (value && !filteredLang.contains(id)) {
                                  selectedKeys.add(id);
                                } else if (!value) {
                                  selectedKeys.remove(id);
                                }
                              });
                            },
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
                    changePage: (page) => locator<TranslationsBloc>().add(GetTranslations(projectId: widget.project.id ?? 0, page: page, name: name)),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFilters)
                    _TranslationsFilter(
                      languages: languages,
                      projectLang: projectLang,
                      filteredLang: filteredLang,
                      filterLanguage: (value, lang) {
                        setState(() {
                          if (value && !filteredLang.contains(lang)) {
                            filteredLang.add(lang);
                          } else if (!value) {
                            filteredLang.remove(lang);
                          }
                        });
                      },
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSecondaryIconButton(
                        icon: Icons.filter_alt_rounded,
                        onPressed: () => setState(() => showFilters = !showFilters),
                      ),
                      SizedBox(width: 10,),
                      AppIconButton(
                        icon: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => TranslationsCreateDialog(
                              projectId: widget.project.id ?? 0,
                              mainLanguage: languages[widget.project.mainLanguage ?? 'en'],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}

class _TranslationsTable extends StatelessWidget {
  final Map<String, dynamic> languages;
  final List<String> filteredLang;
  final List<TransKey> keys;
  final List<int> selectedKeys;
  final void Function(bool, int) selectKey;

  const _TranslationsTable({required this.languages, required this.filteredLang, required this.keys, required this.selectedKeys, required this.selectKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 75,
                  child: Checkbox(
                    value: keys.length == selectedKeys.length,
                    onChanged: (value) {
                      if (value == null) return;
                      if (value) {
                        for (TransKey key in keys) {
                          if (!selectedKeys.contains(key.id ?? 0)) selectKey(true, key.id ?? 0);
                        }
                      } else {
                        for (TransKey key in keys) {
                          if (selectedKeys.contains(key.id ?? 0)) selectKey(false, key.id ?? 0);
                        }
                      }
                    }
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 300,
                  child: Text(
                    'Keys',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                for (String lang in filteredLang)
                  Container(
                  padding: EdgeInsets.only(left: 20),
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
                  for (TransKey key in keys)
                    Row(
                      children: [
                        SizedBox(
                          width: 75,
                          child: Checkbox(
                            value: selectedKeys.contains(key.id),
                            onChanged: (value) {
                              if (value != null) selectKey(value, key.id ?? 0);
                            }
                          ),
                        ),
                        buildKeyCard(key, context),
                        for (String lang in filteredLang)
                          buildTranslationCard(lang, key.translations ?? [], context),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKeyCard(TransKey key, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TranslationsDialog(transKey: key),
        );
      },
      child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          key.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (key.description != null && key.description!.isNotEmpty)
                          Text(
                            key.description!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: key.image != null ? 1 : 4,
                          ),
                        if (key.image != null)
                          Image.network(key.image!),
                        Spacer(),
                        Text(
                          key.createdBy?.name ?? '',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                        Text(
                          key.updatedAt?.toFormatStringDate(context) ?? 'Unknown',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildIconButton(icon: Icons.edit_rounded, onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TranslationsEditDialog(transKey: key),
                      );
                    }),
                    buildIconButton(icon: Icons.check_rounded, onPressed: () {}),
                    buildIconButton(icon: Icons.delete_rounded, onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTranslationCard(String lang, List<Translation> translations, BuildContext context) {
    String text = '';
    String createdBy = '';
    String updatedAt = '';

    for (Translation translation in translations) {
      if (translation.language == lang) {
        text = translation.text.toString();
        createdBy = translation.createdBy?.name ?? '';
        updatedAt = translation.updatedAt?.toFormatStringDate(context) ?? 'Unknown';
        break;
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SingleChildScrollView(child: Text(text,))),
                      Text(
                        createdBy,
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                      Text(
                        updatedAt,
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildIconButton(icon: Icons.edit_rounded, onPressed: () {}),
                  buildIconButton(icon: Icons.check_rounded, onPressed: () {}),
                  buildIconButton(icon: Icons.comment_rounded, onPressed: () {}),
                  buildIconButton(icon: Icons.restore_rounded, onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconButton({required IconData icon, bool isEnabled = true, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, color: isEnabled ? Colors.black45 : Colors.black12,),
    );
  }
}

class _TranslationsFilter extends StatelessWidget {
  final Map<String, dynamic> languages;
  final List<String> projectLang;
  final List<String> filteredLang;
  final void Function(bool, String) filterLanguage;

  const _TranslationsFilter({required this.languages, required this.projectLang, required this.filteredLang, required this.filterLanguage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 70, bottom: 5),
      child: AppElevatedCard(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show Languages:',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5,),
              for (String lang in projectLang)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: filteredLang.contains(lang),
                      onChanged: (value) {
                        if (value != null) filterLanguage(value, lang);
                      },
                    ),
                    Text(languages[lang]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}