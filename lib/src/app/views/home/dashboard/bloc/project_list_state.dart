import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class ProjectListState extends Equatable {
  final String? name;
  final int page;
  final int totalPages;

  const ProjectListState({this.name, required this.page, required this.totalPages});

  @override
  List<Object?> get props => [name, page, totalPages];
}

class ProjectListInitial extends ProjectListState {
  const ProjectListInitial({super.name, super.page = 1, super.totalPages = 1});
}

class ProjectListLoading extends ProjectListState {
  const ProjectListLoading({super.name, required super.page, required super.totalPages});
}

class ProjectListLoaded extends ProjectListState {
  final List<Project> projects;

  const ProjectListLoaded(this.projects, {super.name, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, name, page, totalPages];
}

class ProjectListError extends ProjectListState {
  final dynamic data;

  const ProjectListError(this.data, {super.name, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [data, name, page, totalPages];
}

class ProjectCreated extends ProjectListLoaded {
  final int projectId;

  const ProjectCreated(super.projects, {required this.projectId, super.name, required super.page, required super.totalPages});
}

class ProjectCreateError extends ProjectListLoaded {
  final dynamic data;

  const ProjectCreateError(super.projects, {super.name, required this.data, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, data, name, page, totalPages];
}

class ProjectFromListDeleted extends ProjectListLoaded {
  const ProjectFromListDeleted(super.projects, {super.name, required super.page, required super.totalPages});
}

class ProjectFromListDeleteError extends ProjectListLoaded {
  final dynamic data;

  const ProjectFromListDeleteError(super.projects, {super.name, required this.data, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, data, name, page, totalPages];
}