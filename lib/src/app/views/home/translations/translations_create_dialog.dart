import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

class TranslationsCreateDialog extends StatefulWidget {
  final int projectId;
  final String mainLanguage;
  
  const TranslationsCreateDialog({super.key, required this.projectId, required this.mainLanguage});
  
  @override
  State<TranslationsCreateDialog> createState() => _TranslationsCreateDialogState();
}

class _TranslationsCreateDialogState extends State<TranslationsCreateDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String? description;
  late String translation;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCardTitle(title: 'New Key'),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 20, right: 40, top: 20),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AppOutlinedTextField(
                            label: 'Key Name',
                            hint: 'Type the key name here (no spaces).',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'The key name can\'t be empty.';
                              name = value;
                              return null;
                            },
                          ),
                          SizedBox(height: 20,),
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
                    SizedBox(width: 50,),
                    Expanded(
                      child: AppOutlinedTextField(
                        label: 'Main Translation (${widget.mainLanguage})',
                        hint: 'Type the main translation here.',
                        maxLines: 9,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'The main translation can\'t be empty.';
                          translation = value;
                          return null;
                        },
                      ),
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
                    locator<TranslationsBloc>().add(CreateKey(projectId: widget.projectId, newKey: key, translation: translation));
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