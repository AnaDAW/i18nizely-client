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

  const UpdateProject(this.newProject);

  @override
  List<Object?> get props => [newProject];
}

class DeleteProject extends ProjectEvent {
  final int id;

  const DeleteProject(this.id);

  @override
  List<Object?> get props => [id];
}