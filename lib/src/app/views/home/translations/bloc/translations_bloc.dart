import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  final KeyApi keyApi;
  final TranslationApi translationApi;

  TranslationsBloc(this.keyApi, this.translationApi) : super(const TranslationsInitial()) {
    on<GetTranslations>(_onGetTranslations);
    on<CreateKey>(_onCreateKey);
    on<ResetTranslations>(_onResetTranslations);
  }

  Future<void> _onGetTranslations(GetTranslations event, Emitter<TranslationsState> emit) async {
    emit(TranslationsLoading(page: state.page, totalPages: state.totalPages));
    try {
      final res = await keyApi.getKeys(projectId: event.projectId, page: event.page, name: event.name);
      res.fold((left) {
        emit(TranslationsError(left.data, page: event.page, totalPages: state.totalPages));
      }, (right) {
        emit(TranslationsLoaded(right, page: event.page, totalPages: state.totalPages));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TranslationsError(e.toString(), page: event.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onCreateKey(CreateKey event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    try {
      final res = await keyApi.createKey(projectId: event.projectId, newKey: event.newKey, translation: event.translation);
      await res.fold((left) {
        emit(KeyCreateError((state as TranslationsLoaded).keys, data: left.data, page: state.page, totalPages: state.totalPages));
      }, (right) async {
        emit(KeyCreated((state as TranslationsLoaded).keys, page: state.page, totalPages: state.totalPages));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyCreateError((state as TranslationsLoaded).keys, data: e.toString(), page: state.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onResetTranslations(ResetTranslations event, Emitter<TranslationsState> emit) async {
    emit(const TranslationsInitial());
  }
}