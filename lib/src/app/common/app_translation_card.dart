import 'dart:async';

import 'package:flutter/material.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_user_info.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_event.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';

class AppTranslationCard extends StatefulWidget {
  final int projectId;
  final int keyId;
  final String lang;
  final Translation? translation;
  final VoidCallback openComments;
  final VoidCallback openVersion;

  const AppTranslationCard({super.key, required this.projectId, required this.keyId, required this.lang, required this.translation, required this.openComments, required this.openVersion});

  @override
  State<AppTranslationCard> createState() => _AppTranslationsCardState();
}

class _AppTranslationsCardState extends State<AppTranslationCard> {
  bool isEditing = false;
  bool hasChanged = false;
  late final bool isEmpty;
  String text = '';

  @override
  void initState() {
    isEmpty = widget.translation == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: isEditing ? TextFormField(
                    initialValue: widget.translation?.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Type here the translation...',
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                    style: TextStyle(fontSize: 14),
                    maxLines: 6,
                    onChanged: checkTranslationChanged,
                  ) : isEmpty ? Center(
                    child: Text(
                      'No translation yet.',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(child: Text(widget.translation!.text ?? '',),),
                      ),
                      SizedBox(height: 10,),
                      AppUserInfo(
                        image: widget.translation!.createdBy?.image,
                        initials: widget.translation!.createdBy?.initials ?? '',
                        name: widget.translation!.createdBy?.name ?? 'Unknown User',
                        date: widget.translation!.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date',
                      ),
                    ],
                  ),
                ),
              ),
              isEditing ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: hasChanged ? () async {
                      try {
                        await updateTranslation();
                        setState(() =>  isEditing = false,);
                      } catch (e) {
                        AppSnackBar.showSnackBar(
                          context,
                          text: (e as dynamic)['text']?[0] ?? 'Error adding translation',
                          isError: true
                        );
                      }
                    } : null,
                    icon: Icon(
                      Icons.check_rounded,
                      color: hasChanged ? Colors.green.shade400 : Colors.green.shade100
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() =>  isEditing = false,);
                      hasChanged = false;
                      text = '';
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red.shade400
                    ),
                  ),
                ],
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => setState(() =>  isEditing = true,),
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.black45
                    ),
                  ),
                  IconButton(
                    onPressed: isEmpty ? null : () {
                      locator<TranslationsBloc>().add(ReviewTranslation(
                        projectId: widget.projectId,
                        keyId: widget.keyId,
                        id: widget.translation!.id ?? 0,
                        isReviewed: widget.translation!.isReviewed == false
                      ));
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      color: isEmpty ? Colors.black12 : widget.translation!.isReviewed == true ? Colors.green.shade400 : Colors.black45
                    ),
                  ),
                  IconButton(
                    onPressed: isEmpty ? null : () {
                      locator<CommentsBloc>().add(GetComments(projectId: widget.projectId, keyId: widget.keyId, translationId: widget.translation?.id ?? 0));
                      widget.openComments();
                    },
                    icon: Icon(
                      Icons.comment_rounded,
                      color: isEmpty ? Colors.black12 : Colors.black45
                    ),
                  ),
                  IconButton(
                    onPressed: isEmpty ? null : () {
                      locator<VersionBloc>().add(GetVersions(projectId: widget.projectId, keyId: widget.keyId, translationId: widget.translation?.id ?? 0));
                      widget.openVersion();
                    },
                    icon: Icon(
                      Icons.restore_rounded,
                      color: isEmpty ? Colors.black12 : Colors.black45
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
  
  void checkTranslationChanged(String newText) {
    if (hasChanged && (newText.isEmpty || newText == widget.translation?.text)) {
      setState(() => hasChanged = false,);
    }
    
    if (!hasChanged && newText.isNotEmpty && newText != widget.translation?.text) {
      setState(() => hasChanged = true,);
    }
    text = newText;
  }

  Future<void> updateTranslation() async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<TranslationsBloc>().stream.listen((state) {
      if (state is TranslationUpdated) {
        subscription.cancel();
        completer.complete();
      } else if (state is TranslationUpdateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    if (isEmpty) {
      Translation newTranslation = Translation(language: widget.lang, text: text);
      locator<TranslationsBloc>().add(CreateTranslation(projectId: widget.projectId, keyId: widget.keyId, newTranslation: newTranslation));
    } else {
      locator<TranslationsBloc>().add(UpdateTranslation(projectId: widget.projectId, keyId: widget.keyId, id: widget.translation?.id ?? 0, newText: text));
    }
    return completer.future;
  }
}