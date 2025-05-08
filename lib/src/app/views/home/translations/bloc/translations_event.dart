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