import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  final KeyApi keyApi;
  final TranslationApi translationApi;

  TranslationsBloc(this.keyApi, this.translationApi) : super(const TranslationsInitial()) {
    on<GetTranslations>(_onGetTranslations);
    on<CreateKey>(_onCreateKey);
    on<UpdateKey>(_onUpdateKey);
    on<AddImage>(_onAddImageKey);
    on<RemoveImage>(_onRemoveImageKey);
    on<DeleteKey>(_onDeleteKey);
    on<DeleteMultipleKeys>(_onDeleteMultipleKeys);
    on<CreateTranslation>(_onCreateTranslation);
    on<UpdateTranslation>(_onUpdateTranslation);
    on<ReviewTranslation>(_onReviewTranslation);
    on<ReviewMultipleTranslations>(_onReviewMultipleTranslations);
    on<ResetTranslations>(_onResetTranslations);
  }

  Future<void> _onGetTranslations(GetTranslations event, Emitter<TranslationsState> emit) async {
    emit(TranslationsLoading(page: state.page, totalPages: state.totalPages, name: event.name));
    try {
      final res = await keyApi.getKeys(projectId: event.projectId, page: event.page, name: event.name);
      res.fold((left) {
        emit(TranslationsError(left.data, page: event.page, totalPages: state.totalPages, name: event.name));
      }, (right) {
        emit(TranslationsLoaded(right, page: event.page, totalPages: state.totalPages, name: event.name));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TranslationsError(e.toString(), page: event.page, totalPages: state.totalPages, name: event.name));
    }
  }

  Future<void> _onCreateKey(CreateKey event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await keyApi.createKey(projectId: event.projectId, newKey: event.newKey, translation: event.translation);
      await res.fold((left) {
        emit(KeyCreateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(KeyCreated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyCreateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onUpdateKey(UpdateKey event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await keyApi.updateKey(projectId: event.projectId, newKey: event.newKey);
      await res.fold((left) {
        emit(KeyUpdateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(KeyUpdated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.page, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyUpdateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onAddImageKey(AddImage event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await keyApi.addImage(projectId: event.projectId, id: event.id, imagePath: event.imagePath);
      await res.fold((left) {
        emit(KeyUpdateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(KeyUpdated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.page, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyUpdateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onRemoveImageKey(RemoveImage event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await keyApi.removeImage(projectId: event.projectId, id: event.id);
      await res.fold((left) {
        emit(KeyUpdateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(KeyUpdated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.page, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyUpdateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onDeleteKey(DeleteKey event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await keyApi.deleteKey(projectId: event.projectId, id: event.id);
      await res.fold((left) {
        emit(KeyDeleteError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(KeyDeleted(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(KeyDeleteError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onDeleteMultipleKeys(DeleteMultipleKeys event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    int errors = 0;
    int success = 0;

    for (int id in event.ids) {
      try {
        final res = await keyApi.deleteKey(projectId: event.projectId, id: id);
        res.fold((left) => errors++, (right) => success++);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }

    if (errors > 0) {
      emit(KeyDeleteError(loadedState.keys, data: {'errors': errors, 'success': success}, page: state.page, totalPages: state.totalPages, name: state.name));
    } else {
      emit(KeyDeleted(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
    }

    if (success > 0) await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages, name: state.name), emit);
  }

  Future<void> _onCreateTranslation(CreateTranslation event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await translationApi.createTranslation(projectId: event.projectId, keyId: event.keyId, newTranslation: event.newTranslation);
      await res.fold((left) {
        emit(TranslationUpdateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(TranslationUpdated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TranslationUpdateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onUpdateTranslation(UpdateTranslation event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await translationApi.updateTranslation(projectId: event.projectId, keyId: event.keyId, id: event.id, newText: event.newText);
      await res.fold((left) {
        emit(TranslationUpdateError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(TranslationUpdated(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.page, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TranslationUpdateError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onReviewTranslation(ReviewTranslation event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    try {
      final res = await translationApi.reviewTranslation(projectId: event.projectId, keyId: event.keyId, id: event.id, isReviewed: event.isReviewed);
      await res.fold((left) {
        emit(TranslationReviewError(loadedState.keys, data: left.data, page: state.page, totalPages: state.totalPages, name: state.name));
      }, (right) async {
        emit(TranslationReviewed(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
        await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.page, name: state.name), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TranslationReviewError(loadedState.keys, data: e.toString(), page: state.page, totalPages: state.totalPages, name: state.name));
    }
  }

  Future<void> _onReviewMultipleTranslations(ReviewMultipleTranslations event, Emitter<TranslationsState> emit) async {
    if (state is! TranslationsLoaded) return;
    TranslationsLoaded loadedState = state as TranslationsLoaded;
    TransKey? key = loadedState.keys.where((k) => k.id == event.keyId).firstOrNull;

    if (key == null) return;
    int errors = 0;
    int success = 0;

    for (Translation translation in key.translations ?? []) {
      if (translation.isReviewed == true) continue;
      try {
        final res = await translationApi.reviewTranslation(projectId: event.projectId, keyId: event.keyId, id: translation.id ?? 0, isReviewed: true);
        res.fold((left) => errors++, (right) => success++);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }

    if (errors > 0) {
      emit(TranslationReviewError(loadedState.keys, data: {'errors': errors, 'success': success}, page: state.page, totalPages: state.totalPages, name: state.name));
    } else {
      emit(TranslationReviewed(loadedState.keys, page: state.page, totalPages: state.totalPages, name: state.name));
    }

    if (success > 0) await _onGetTranslations(GetTranslations(projectId: event.projectId, page: state.totalPages, name: state.name), emit);
  }

  Future<void> _onResetTranslations(ResetTranslations event, Emitter<TranslationsState> emit) async {
    emit(const TranslationsInitial());
  }
}