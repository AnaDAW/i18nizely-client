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
  final dynamic data;

  const ProjectError(this.data);

  @override
  List<Object?> get props => [data];
}

class ProjectUpdated extends ProjectLoaded {
  const ProjectUpdated(super.project);
}

class ProjectUpdateError extends ProjectLoaded {
  final dynamic data;

  const ProjectUpdateError(super.project, {required this.data});

  @override
  List<Object?> get props => [data, project];
}

class ProjectDeleted extends ProjectInitial {
  const ProjectDeleted();
}

class ProjectDeleteError extends ProjectLoaded {
  final dynamic data;

  const ProjectDeleteError(super.project, {required this.data});

  @override
  List<Object?> get props => [data, project];
}

class CollaboratorAdded extends ProjectLoaded {
  const CollaboratorAdded(super.project);
}

class CollaboratorAddError extends ProjectLoaded {
  final dynamic data;

  const CollaboratorAddError(super.project, {required this.data});

  @override
  List<Object?> get props => [data, project];
}

class CollaboratorUpdated extends ProjectLoaded {
  const CollaboratorUpdated(super.project);
}

class CollaboratorUpdateError extends ProjectLoaded {
  final dynamic data;

  const CollaboratorUpdateError(super.project, {required this.data});

  @override
  List<Object?> get props => [data, project];
}

class CollaboratorRemoved extends ProjectLoaded {
  const CollaboratorRemoved(super.project);
}

class CollaboratorRemoveError extends ProjectLoaded {
  final dynamic data;

  const CollaboratorRemoveError(super.project, {required this.data});

  @override
  List<Object?> get props => [data, project];
}