import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

class TranslationsState extends Equatable {
  final int page;
  final int totalPages;
  final String? name;

  const TranslationsState({required this.page, required this.totalPages, this.name});

  @override
  List<Object?> get props => [page, totalPages, name];
}

class TranslationsInitial extends TranslationsState {
  const TranslationsInitial({super.page = 1, super.totalPages = 1, super.name});
}

class TranslationsLoading extends TranslationsState {
  const TranslationsLoading({required super.page, required super.totalPages, super.name});
}

class TranslationsLoaded extends TranslationsState {
  final List<TransKey> keys;

  const TranslationsLoaded(this.keys, {required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, page, totalPages, name];
}

class TranslationsError extends TranslationsState {
  final dynamic data;

  const TranslationsError(this.data, {required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [data, page, totalPages, name];
}

class KeyCreated extends TranslationsLoaded {
  const KeyCreated(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyCreateError extends TranslationsLoaded {
  final dynamic data;

  const KeyCreateError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class KeyUpdated extends TranslationsLoaded {
  const KeyUpdated(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyUpdateError extends TranslationsLoaded {
  final dynamic data;

  const KeyUpdateError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class KeyDeleted extends TranslationsLoaded {
  const KeyDeleted(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyDeleteError extends TranslationsLoaded {
  final dynamic data;

  const KeyDeleteError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class KeyImporting extends TranslationsLoaded {
  const KeyImporting(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyImported extends TranslationsLoaded {
  const KeyImported(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyImportError extends TranslationsLoaded {
  final dynamic data;

  const KeyImportError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class KeyExporting extends TranslationsLoaded {
  const KeyExporting(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyExported extends TranslationsLoaded {
  const KeyExported(super.keys, {required super.page, required super.totalPages, super.name});
}

class KeyExportError extends TranslationsLoaded {
  final dynamic data;

  const KeyExportError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class TranslationUpdated extends TranslationsLoaded {
  const TranslationUpdated(super.keys, {required super.page, required super.totalPages, super.name});
}

class TranslationUpdateError extends TranslationsLoaded {
  final dynamic data;

  const TranslationUpdateError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}

class TranslationReviewed extends TranslationsLoaded {
  const TranslationReviewed(super.keys, {required super.page, required super.totalPages, super.name});
}

class TranslationReviewError extends TranslationsLoaded {
  final dynamic data;

  const TranslationReviewError(super.keys, {required this.data, required super.page, required super.totalPages, super.name});

  @override
  List<Object?> get props => [keys, data, page, totalPages, name];
}