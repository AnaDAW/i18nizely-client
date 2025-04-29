import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  final KeyApi keyApi;

  TranslationsBloc(this.keyApi) : super(const TranslationsInitial()) {
    on<GetTranslations>(_onGetTranslations);
  }

  Future<void> _onGetTranslations(GetTranslations event, Emitter<TranslationsState> emit) async {
    emit(TranslationsLoading(page: state.page, totalPages: state.totalPages));
    try {
      final res = await keyApi.getKeys(projectId: event.projectId, page: event.page);
      res.fold((left) {
        emit(TranslationsError(left.message.toString(), page: event.page, totalPages: state.totalPages));
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
}