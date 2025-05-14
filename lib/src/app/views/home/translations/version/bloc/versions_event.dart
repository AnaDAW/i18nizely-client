import 'package:equatable/equatable.dart';

abstract class VersionsEvent extends Equatable {
  const VersionsEvent();

  @override
  List<Object?> get props => [];
}

class GetVersions extends VersionsEvent {
  final int projectId;
  final int keyId;
  final int translationId;

  const GetVersions({required this.projectId, required this.keyId, required this.translationId});

  @override
  List<Object?> get props => [projectId, keyId, translationId];
}

class ResetVersions extends VersionsEvent {
  const ResetVersions();
}

class UpdateVersions extends VersionsEvent {
  final int translationId;

  const UpdateVersions(this.translationId);

  @override
  List<Object?> get props => [translationId];
}