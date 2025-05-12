import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class GetProject extends ProjectEvent {
  final int id;

  const GetProject(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateProject extends ProjectEvent {
  final Project newProject;
  final List<String>? languages;

  const UpdateProject(this.newProject, {this.languages});

  @override
  List<Object?> get props => [newProject, languages];
}

class DeleteProject extends ProjectEvent {
  final int? id;

  const DeleteProject({this.id});

  @override
  List<Object?> get props => [id];
}

class AddCollaborator extends ProjectEvent {
  final Collaborator newCollaborator;

  const AddCollaborator({required this.newCollaborator});

  @override
  List<Object?> get props => [newCollaborator];
}

class UpdateCollaborator extends ProjectEvent {
  final int id;
  final List<CollabRole> roles;

  const UpdateCollaborator({required this.id, required this.roles});

  @override
  List<Object?> get props => [id, roles];
}

class RemoveCollaborator extends ProjectEvent {
  final int id;

  const RemoveCollaborator({required this.id});

  @override
  List<Object?> get props => [id];
}

class ResetProject extends ProjectEvent {
  const ResetProject();
}