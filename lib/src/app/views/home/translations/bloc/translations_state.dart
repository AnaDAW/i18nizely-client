import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

class TranslationsState extends Equatable {
  final int page;
  final int totalPages;

  const TranslationsState({required this.page, required this.totalPages});

  @override
  List<Object?> get props => [page, totalPages];
}

class TranslationsInitial extends TranslationsState {
  const TranslationsInitial({super.page = 1, super.totalPages = 1});
}

class TranslationsLoading extends TranslationsState {
  const TranslationsLoading({required super.page, required super.totalPages});
}

class TranslationsLoaded extends TranslationsState {
  final List<TransKey> keys;

  const TranslationsLoaded(this.keys, {required super.page, required super.totalPages});

  @override
  List<Object?> get props => [keys, page, totalPages];
}

class TranslationsError extends TranslationsState {
  final String message;

  const TranslationsError(this.message, {required super.page, required super.totalPages});

  @override
  List<Object?> get props => [message, page, totalPages];
}

class KeyCreateError extends TranslationsLoaded {
  final String message;

  const KeyCreateError(super.keys, {required this.message, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [keys, message, page, totalPages];
}