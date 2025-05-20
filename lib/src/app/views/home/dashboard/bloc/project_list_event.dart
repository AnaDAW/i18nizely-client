import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

abstract class ProjectListEvent extends Equatable {
  const ProjectListEvent();

  @override
  List<Object?> get props => [];
}

class GetProjects extends ProjectListEvent {
  final int page;
  final String? name;

  const GetProjects({required this.page, this.name});

  @override
  List<Object?> get props => [page, name];
}

class CreateProject extends ProjectListEvent {
  final Project project;
  final List<String> languages;

  const CreateProject(this.project, {required this.languages});

  @override
  List<Object?> get props => [project, languages];
}

class UpdateProjectList extends ProjectListEvent {
  final Project project;

  const UpdateProjectList(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProjectFromList extends ProjectListEvent {
  final int id;
  final bool refresh;

  const DeleteProjectFromList(this.id, {this.refresh = false});

  @override
  List<Object?> get props => [id, refresh];
}

class ResetProjectList extends ProjectListEvent {
  const ResetProjectList();
}