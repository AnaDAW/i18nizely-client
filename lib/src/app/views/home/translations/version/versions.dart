import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/src/app/common/app_tab_item.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_event.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/version_model.dart';

class VersionsTab extends StatelessWidget {
  final VoidCallback closeTab;

  const VersionsTab({super.key, required this.closeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                IconButton(
                  onPressed: closeTab,
                  icon: Icon(Icons.close)
                ),
                Center(
                  child: Text(
                    'Versions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<VersionBloc, VersionsState>(
              builder: (context, state) {
                if (state is VersionsLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
                } else if (state is VersionsError) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_rounded, color: Colors.red.shade400,),
                        SizedBox(width: 5,),
                        Text(
                          'Error getting the versions.',
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ],
                    ),
                  );
                } else if (state is VersionsLoaded) {
                  if (state.versions.isEmpty) {
                    return Center(
                      child: Text(
                        'No versions yet.',
                        style: TextStyle(color: Colors.black45),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.versions.length,
                    itemBuilder: (context, index) {
                      Version version = state.versions.reversed.toList()[index];

                      return AppTabItem(
                        user: version.createdBy,
                        date: version.createdAt,
                        trailing: IconButton(
                          onPressed: () => updateTranslation(state, version.text),
                          icon: Icon(Icons.rotate_left_rounded, color: Colors.white,),
                        ),
                        text: version.text
                      );
                    },
                  );
                }
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_rounded, color: Colors.red.shade400,),
                      SizedBox(width: 5,),
                      Text(
                        'Versions not found.',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15,)
        ],
      ),
    );
  }

  Future<void> updateTranslation(VersionsLoaded versionState, String text) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<TranslationsBloc>().stream.listen((state) {
      if (state is TranslationUpdated) {
        subscription.cancel();
        completer.complete();
        locator<VersionBloc>().add(GetVersions(projectId: versionState.projectId, keyId: versionState.keyId, translationId: versionState.translationId));
      } else if (state is TranslationUpdateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<TranslationsBloc>().add(UpdateTranslation(projectId: versionState.projectId, keyId: versionState.keyId, id: versionState.translationId, newText: text));
    return completer.future;
  }
}