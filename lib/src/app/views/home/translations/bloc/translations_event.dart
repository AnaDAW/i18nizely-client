import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';

abstract class TranslationsEvent extends Equatable {
  const TranslationsEvent();

  @override
  List<Object?> get props => [];
}

class GetTranslations extends TranslationsEvent {
  final int projectId;
  final int page;
  final String? name;

  const GetTranslations({required this.projectId, required this.page, this.name});

  @override
  List<Object?> get props => [projectId, page, name];
}

class CreateKey extends TranslationsEvent {
  final int projectId;
  final TransKey newKey;
  final String translation;

  const CreateKey({required this.projectId, required this.newKey, required this.translation});

  @override
  List<Object?> get props => [projectId, newKey, translation];
}

class UpdateKey extends TranslationsEvent {
  final int projectId;
  final TransKey newKey;

  const UpdateKey({required this.projectId, required this.newKey});

  @override
  List<Object?> get props => [projectId, newKey];
}

class AddImage extends TranslationsEvent {
  final int projectId;
  final int id;
  final String imagePath;

  const AddImage({required this.projectId, required this.id, required this.imagePath});

  @override
  List<Object?> get props => [projectId, id, imagePath];
}

class RemoveImage extends TranslationsEvent {
  final int projectId;
  final int id;

  const RemoveImage({required this.projectId, required this.id});

  @override
  List<Object?> get props => [projectId, id];
}

class DeleteKey extends TranslationsEvent {
  final int projectId;
  final int id;

  const DeleteKey({required this.projectId, required this.id});

  @override
  List<Object?> get props => [projectId, id];
}

class DeleteMultipleKeys extends TranslationsEvent {
  final int projectId;
  final List<int> ids;

  const DeleteMultipleKeys({required this.projectId, required this.ids});

  @override
  List<Object?> get props => [projectId, ids];
}

class ImportKeys extends TranslationsEvent {
  final int projectId;
  final Map<String, String> files;

  const ImportKeys({required this.projectId, required this.files});

  @override
  List<Object?> get props => [projectId, files];
}

class ExportKeys extends TranslationsEvent {
  final int projectId;
  final String filePath;
  final List<String>? fileTypes;
  final List<String>? languages;
  final bool onlyReviewed;

  const ExportKeys({required this.projectId, required this.filePath, this.fileTypes, this.languages, this.onlyReviewed = false});

  @override
  List<Object?> get props => [projectId, filePath, fileTypes, languages, onlyReviewed];
}

class CreateTranslation extends TranslationsEvent {
  final int projectId;
  final int keyId;
  final Translation newTranslation;

  const CreateTranslation({required this.projectId, required this.keyId, required this.newTranslation});

  @override
  List<Object?> get props => [projectId, keyId, newTranslation];
}

class UpdateTranslation extends TranslationsEvent {
  final int projectId;
  final int keyId;
  final int id;
  final String newText;

  const UpdateTranslation({required this.projectId, required this.keyId, required this.id, required this.newText});

  @override
  List<Object?> get props => [projectId, keyId, id, newText];
}

class ReviewTranslation extends TranslationsEvent {
  final int projectId;
  final int keyId;
  final int id;
  final bool isReviewed;

  const ReviewTranslation({required this.projectId, required this.keyId, required this.id, required this.isReviewed});

  @override
  List<Object?> get props => [projectId, keyId, id, isReviewed];
}

class ReviewMultipleTranslations extends TranslationsEvent {
  final int projectId;
  final int keyId;

  const ReviewMultipleTranslations({required this.projectId, required this.keyId});

  @override
  List<Object?> get props => [projectId, keyId];
}

class ResetTranslations extends TranslationsEvent {
  const ResetTranslations();
}