import 'package:equatable/equatable.dart';

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
  List<Object?> get props => [projectId];
}