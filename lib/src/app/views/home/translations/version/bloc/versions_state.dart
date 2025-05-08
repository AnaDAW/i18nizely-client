import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/version_model.dart';

class VersionsState extends Equatable {

  const VersionsState();

  @override
  List<Object?> get props => [];
}

class VersionsInitial extends VersionsState {
  const VersionsInitial();
}

class VersionsLoading extends VersionsState {
  const VersionsLoading();
}

class VersionsLoaded extends VersionsState {
  final int projectId;
  final int keyId;
  final int translationId;
  final List<Version> versions;

  const VersionsLoaded(this.versions, {required this.projectId, required this.keyId, required this.translationId});

  @override
  List<Object?> get props => [versions, projectId, keyId, translationId];
}

class VersionsError extends VersionsState {
  final dynamic data;

  const VersionsError(this.data);

  @override
  List<Object?> get props => [data];
}