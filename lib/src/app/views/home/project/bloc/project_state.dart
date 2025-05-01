import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

class ProjectLoaded extends ProjectState {
  final Project project;

  const ProjectLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectUpdated extends ProjectLoaded {
  const ProjectUpdated(super.project);
}

class ProjectUpdateError extends ProjectLoaded {
  final String message;

  const ProjectUpdateError(super.project, {required this.message});

  @override
  List<Object?> get props => [message, project];
}

class ProjectDeleted extends ProjectInitial {
  const ProjectDeleted();
}

class ProjectDeleteError extends ProjectLoaded {
  final String message;

  const ProjectDeleteError(super.project, {required this.message});

  @override
  List<Object?> get props => [message, project];
}