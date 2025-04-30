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

  const GetTranslations({required this.projectId, required this.page});

  @override
  List<Object?> get props => [projectId, page];
}

class CreateKey extends TranslationsEvent {
  final int projectId;
  final TransKey newKey;

  const CreateKey({required this.projectId, required this.newKey});

  @override
  List<Object?> get props => [projectId, newKey];
}