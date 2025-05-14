import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:image_picker/image_picker.dart';

class TranslationsEditDialog extends StatefulWidget {
  final int projectId;
  final TransKey transKey;
  
  const TranslationsEditDialog({super.key, required this.projectId, required this.transKey});
  
  @override
  State<TranslationsEditDialog> createState() => _TranslationsEditDialogState();
}

class _TranslationsEditDialogState extends State<TranslationsEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String? description;
  late String? image;

  @override
  void initState() {
    name = widget.transKey.name ?? '';
    description = widget.transKey.description;
    image = widget.transKey.image;
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
                            initialValue: name,
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
                            initialValue: description,
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
                      child: Container(
                        height: 272,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.detail)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Center(
                              child: image != null && image!.isNotEmpty ? Image.network(
                                image!,
                                fit: BoxFit.contain,
                              ) : Text(
                                'No context image.',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (image != null && image!.isNotEmpty)
                                    SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: AppIconButton(
                                        icon: Icons.delete,
                                        primary: false,
                                        onPressed: () async {
                                          locator<TranslationsBloc>().add(RemoveImage(projectId: widget.projectId, id: widget.transKey.id ?? 0));
                                          setState(() => image = null);
                                        }
                                      ),
                                    ),
                                  Spacer(),
                                  AppIconButton(
                                    icon: Icons.edit_rounded,
                                    onPressed: () async {
                                      final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (file != null) {
                                        locator<TranslationsBloc>().add(AddImage(projectId: widget.projectId, id: widget.transKey.id ?? 0, imagePath: file.path));
                                      }
                                    }
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                  Expanded(child: AppStyledButton(text: 'Save', onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    TransKey updatedKey = getUpdatedKey();
                    if (updatedKey == TransKey(id: widget.transKey.id)) return;
                    
                    locator<TranslationsBloc>().add(UpdateKey(projectId: widget.projectId, newKey: updatedKey));
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

  TransKey getUpdatedKey() {
    return TransKey(
      id: widget.transKey.id,
      name: widget.transKey.name != name ? name : null,
      description: widget.transKey.description != description ? description : null,
    );
  }
}