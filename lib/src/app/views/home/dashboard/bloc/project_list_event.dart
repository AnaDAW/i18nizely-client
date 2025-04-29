import 'package:equatable/equatable.dart';

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

class CreatedProjectFromList extends ProjectListEvent {
  const CreatedProjectFromList();
}

class UpdateProjectFromList extends ProjectListEvent {
  final int id;

  const UpdateProjectFromList(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteProjectFromList extends ProjectListEvent {
  final int id;
  final bool refresh;

  const DeleteProjectFromList(this.id, {this.refresh = false});

  @override
  List<Object?> get props => [id, refresh];
}