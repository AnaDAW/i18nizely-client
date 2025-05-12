import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/common/app_confirmation_dialog.dart';
import 'package:i18nizely/src/app/common/app_user_info.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/dialogs/key_dialog.dart';
import 'package:i18nizely/src/app/views/home/translations/dialogs/translations_edit_dialog.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

class AppKeyCard extends StatelessWidget {
  final int projectId;
  final TransKey transKey;

  const AppKeyCard({super.key, required this.projectId, required this.transKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => KeyDialog(transKey: transKey),
        );
      },
      child: Container(
        height: 200,
        width: 300,
        padding: EdgeInsets.all(10),
        child: AppElevatedCard(
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
                        transKey.name.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (transKey.description != null && transKey.description!.isNotEmpty)
                        Text(
                          transKey.description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: transKey.image != null ? 1 : 4,
                        ),
                      if (transKey.image != null)
                        Image.network(transKey.image!),
                      Spacer(),
                      AppUserInfo(
                        image: transKey.createdBy?.image,
                        initials: transKey.createdBy?.initials ?? '',
                        name: transKey.createdBy?.name ?? 'Unknown User',
                        date: transKey.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date',
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TranslationsEditDialog(projectId: projectId, transKey: transKey),
                      );
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.black45
                    ),
                  ),
                  IconButton(
                    onPressed: () => locator<TranslationsBloc>().add(ReviewMultipleTranslations(projectId: projectId, keyId: transKey.id ?? 0,)),
                    icon: Icon(
                      Icons.check_rounded,
                      color: Colors.black45
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppConfirmationDialog(
                            title: 'Delete Key',
                            description: 'Are you sure you want to delete the key?',
                            button: 'Delete',
                            onPressed: () {
                              locator<TranslationsBloc>().add(DeleteKey(projectId: projectId, id: transKey.id ?? 0));
                              context.pop();
                            },
                          ),
                      );
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red.shade400
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}