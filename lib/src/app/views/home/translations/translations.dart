import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_confirmation_dialog.dart';
import 'package:i18nizely/src/app/common/app_key_card.dart';
import 'package:i18nizely/src/app/common/app_pages_bar.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/common/app_translation_card.dart';
import 'package:i18nizely/src/app/views/home/notifications/notifications.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/comments.dart';
import 'package:i18nizely/src/app/views/home/translations/dialogs/translations_create_dialog.dart';
import 'package:i18nizely/src/app/views/home/translations/version/versions.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

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

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
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
        ),
        NotificationsTab(),
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
  final List<String> hiddenLang = [];
  String? name;
  bool showFilters = false;
  final List<int> selectedKeys = [];
  bool openComments = false;
  bool openVersion = false;

  @override
  void initState() {
    projectLang = [widget.project.mainLanguage ?? ''];
    projectLang.addAll(widget.project.languages?.where((lang) => lang.code != widget.project.mainLanguage).map((lang) => lang.code) ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocConsumer<TranslationsBloc, TranslationsState>(
            listener: (context, state) {
              if (state is KeyCreated) {
                AppSnackBar.showSnackBar(context, text: 'Key created');
              } else if (state is KeyCreateError) {
                AppSnackBar.showSnackBar(context, text: 'Error creating key', isError: true);
              } else if (state is KeyUpdated) {
                AppSnackBar.showSnackBar(context, text: 'Key updated');
              } else if (state is KeyUpdateError) {
                AppSnackBar.showSnackBar(context, text: 'Error updating key', isError: true);
              } else if (state is KeyDeleted) {
                AppSnackBar.showSnackBar(context, text: 'Key deleted');
              } else if (state is KeyDeleteError) {
                AppSnackBar.showSnackBar(context, text: 'Error deleting key', isError: true);
              } else if (state is TranslationUpdated) {
                AppSnackBar.showSnackBar(context, text: 'Translation updated');
              } else if (state is TranslationReviewed) {
                AppSnackBar.showSnackBar(context, text: 'Translation reviewed');
              } else if (state is TranslationReviewError) {
                AppSnackBar.showSnackBar(context, text: 'Error reviewing translation', isError: true);
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
                                  projectId: widget.project.id ?? 0,
                                  languages: languages,
                                  projectLang: projectLang,
                                  hiddenLang: hiddenLang,
                                  keys: state.keys,
                                  selectedKeys: selectedKeys,
                                  selectKey: (value, id) {
                                    setState(() {
                                      if (value && !selectedKeys.contains(id)) {
                                        selectedKeys.add(id);
                                      } else if (!value) {
                                        selectedKeys.remove(id);
                                      }
                                    });
                                  },
                                  openComments: () {
                                    setState(() {
                                      openVersion = false;
                                      openComments = true;
                                    });
                                  },
                                  openVersion: () {
                                    setState(() {
                                      openComments = false;
                                      openVersion = true;
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
                    padding: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (showFilters)
                              _TranslationsFilter(
                                languages: languages,
                                projectLang: projectLang,
                                hiddenLang: hiddenLang,
                                filterLanguage: (value, lang) {
                                  setState(() {
                                    if (!value && !hiddenLang.contains(lang)) {
                                      hiddenLang.add(lang);
                                    } else if (value) {
                                      hiddenLang.remove(lang);
                                    }
                                  });
                                },
                              ),
                            SizedBox(width: 17,),
                            if (selectedKeys.isNotEmpty)
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: AppIconButton(
                                  icon: Icons.delete_rounded,
                                  primary: false,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AppConfirmationDialog(
                                        title: 'Delete Keys',
                                        description: 'Are you sure you want to delete the keys?',
                                        button: 'Delete',
                                        onPressed: () async {
                                          try {
                                            await deleteKeys();
                                            setState(() => selectedKeys.clear());
                                          } catch (e) {
                                            dynamic data = e as dynamic;
                                            AppSnackBar.showSnackBar(
                                              context,
                                              text: 'Error deleting keys. Deleted: ${data['succes']}, Errors: ${data['errors']}',
                                              isError: true
                                            );
                                          }
                                          context.pop();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            SizedBox(width: selectedKeys.isNotEmpty ? 8 : 53,),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppSecondaryIconButton(
                              icon: Icons.filter_alt_rounded,
                              isEnabled: !showFilters,
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
          ),
        ),
        if (openComments) CommentsTab(closeTab: () => setState(() => openComments = false,),),
        if (openVersion) VersionsTab(closeTab: () => setState(() => openVersion = false,),),
      ],
    );
  }

  Future<void> deleteKeys() async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<TranslationsBloc>().stream.listen((state) {
      if (state is KeyDeleted) {
        subscription.cancel();
        completer.complete();
      } else if (state is KeyDeleteError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<TranslationsBloc>().add(DeleteMultipleKeys(projectId: widget.project.id ?? 0, ids: selectedKeys));
    return completer.future;
  }
}

class _TranslationsTable extends StatelessWidget {
  final int projectId;
  final Map<String, dynamic> languages;
  final List<String> projectLang;
  final List<String> hiddenLang;
  final List<TransKey> keys;
  final List<int> selectedKeys;
  final void Function(bool, int) selectKey;
  final VoidCallback openComments;
  final VoidCallback openVersion;

  const _TranslationsTable({required this.projectId, required this.languages, required this.projectLang, required this.hiddenLang, required this.keys, required this.selectedKeys, required this.selectKey, required this.openComments, required this.openVersion});

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
                    value: keys.isEmpty ? false : keys.length == selectedKeys.length,
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
                for (String lang in projectLang)
                  if (!hiddenLang.contains(lang))
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
                        AppKeyCard(projectId: projectId, transKey: key),
                        for (String lang in projectLang)
                          if (!hiddenLang.contains(lang))
                            AppTranslationCard(
                              key: Key('$key$lang'),
                              projectId: projectId,
                              keyId: key.id ?? 0,
                              language: lang,
                              langName: languages[lang],
                              translation: key.translations?.where((trans) => trans.language == lang).firstOrNull,
                              openComments: openComments,
                              openVersion: openVersion,
                            ),
                        SizedBox(width: 20,),
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

  Widget buildIconButton({required IconData icon, bool isEnabled = true, required VoidCallback onPressed, Color? color}) {
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(
        icon,
        color: color ?? (isEnabled ? Colors.black45 : Colors.black12),
      ),
    );
  }
}

class _TranslationsFilter extends StatelessWidget {
  final Map<String, dynamic> languages;
  final List<String> projectLang;
  final List<String> hiddenLang;
  final void Function(bool, String) filterLanguage;

  const _TranslationsFilter({required this.languages, required this.projectLang, required this.hiddenLang, required this.filterLanguage});

  @override
  Widget build(BuildContext context) {
    return AppElevatedCard(
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
                  value: !hiddenLang.contains(lang),
                  onChanged: (value) {
                    if (value != null) filterLanguage(value, lang);
                  },
                ),
                Text(languages[lang]),
              ],
            ),
        ],
      ),
    );
  }
}