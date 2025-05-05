import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

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

class ResetTranslations extends TranslationsEvent {
  const ResetTranslations();
}