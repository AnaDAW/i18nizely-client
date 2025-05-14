import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_event.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_state.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';

class VersionsBloc extends Bloc<VersionsEvent, VersionsState> {
  final TranslationApi translationApi;

  VersionsBloc(this.translationApi) : super(const VersionsInitial()) {
    on<GetVersions>(_onGetVersions);
    on<UpdateVersions>(_onUpdateVersions);
    on<ResetVersions>(_onResetVersions);
  }

  Future<void> _onGetVersions(GetVersions event, Emitter<VersionsState> emit) async {
    emit(VersionsLoading());
    try {
      final res = await translationApi.getVersions(projectId: event.projectId, keyId: event.keyId, translationId: event.translationId);
      res.fold((left) {
        emit(VersionsError(left.data));
      }, (right) {
        emit(VersionsLoaded(right, projectId: event.projectId, keyId: event.keyId, translationId: event.translationId));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(VersionsError(e.toString()));
    }
  }

  Future<void> _onUpdateVersions(UpdateVersions event, Emitter<VersionsState> emit) async {
    if (state is! VersionsLoaded) return;
    VersionsLoaded loadedState = state as VersionsLoaded;
    if (event.translationId == loadedState.translationId) {
      await _onGetVersions(GetVersions(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId), emit);
    }
  }

  Future<void> _onResetVersions(ResetVersions event, Emitter<VersionsState> emit) async {
    emit(const VersionsInitial());
  }
}