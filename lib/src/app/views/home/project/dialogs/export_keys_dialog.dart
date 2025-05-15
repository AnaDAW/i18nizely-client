import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/domain/models/file_utils.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class ExportKeysDialog extends StatefulWidget {
  final Project project;
  final Map<String, dynamic> languages;
  
  const ExportKeysDialog({super.key, required this.project, required this.languages});
  
  @override
  State<ExportKeysDialog> createState() => _ExportKeysDialogState();
}

class _ExportKeysDialogState extends State<ExportKeysDialog> {
  final List<String> fileTypes = ['json', 'arb'];
  late final List<String> typesSelected;
  late final List<String> languagesSelected;
  bool onlyReviewed = false;

  @override
  void initState() {
    typesSelected = List.of(fileTypes);
    languagesSelected = widget.project.languageCodes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCardTitle(title: 'Export Keys'),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 20, right: 40, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: checkTotalExport(),
                              onChanged: (value) {
                                if (value == null) return;
                                if (value) {
                                  setState(() {
                                    typesSelected.addAll(fileTypes);
                                    languagesSelected.addAll(widget.project.languageCodes);
                                  });
                                } else {
                                  setState(() {
                                    typesSelected.clear();
                                    languagesSelected.clear();
                                  });
                                }
                              },
                            ),
                            Text('Total Export', style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text('File Types', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (String type in fileTypes)
                              Row(
                                children: [
                                  Checkbox(
                                    value: typesSelected.contains(type),
                                    onChanged: (value) {
                                      if (value == null) return;
                                      if (value && !typesSelected.contains(type)) {
                                        setState(() => typesSelected.add(type));
                                      } else if (!value) {
                                        setState(() => typesSelected.remove(type));
                                      }
                                    },
                                  ),
                                  Text(type),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Checkbox(
                              value: onlyReviewed,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => onlyReviewed = value);
                              },
                            ),
                            Text('Only Reviewed Translations', style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Languages', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (String lang in widget.project.languageCodes)
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: languagesSelected.contains(lang),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          if (value && !languagesSelected.contains(lang)) {
                                            setState(() => languagesSelected.add(lang));
                                          } else if (!value) {
                                            setState(() => languagesSelected.remove(lang));
                                          }
                                        },
                                      ),
                                      Text(widget.languages[lang]),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: AppOutlinedButton(onPressed: () => context.pop(), text: 'Cancel')),
                  SizedBox(width: 50,),
                  Expanded(child: AppStyledButton(text: 'Export', onPressed: () async {
                    if (typesSelected.isEmpty || languagesSelected.isEmpty) return;
                    final String? filePath = await saveZipFile(widget.project.name?.toLowerCase().replaceAll(' ', '-') ?? 'unnamed');
                    print(filePath);
                    if (filePath != null) {
                      locator<TranslationsBloc>().add(ExportKeys(
                        projectId: widget.project.id ?? 0,
                        filePath: filePath.endsWith('.zip') ? filePath : '$filePath.zip',
                        fileTypes: typesSelected,
                        languages: languagesSelected,
                        onlyReviewed: onlyReviewed
                      ));
                    }
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

  bool checkTotalExport() {
    for (String lang in widget.project.languageCodes) {
      if (!languagesSelected.contains(lang)) return false;
    }
    for (String type in fileTypes) {
      if (!typesSelected.contains(type)) return false;
    }
    return true;
  }
}