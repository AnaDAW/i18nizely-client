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
  List<Object?> get props => [page];
}

class UpdateProject extends ProjectListEvent {
  final int id;

  const UpdateProject({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProject extends ProjectListEvent {
  final int id;

  const DeleteProject({required this.id});

  @override
  List<Object?> get props => [id];
}