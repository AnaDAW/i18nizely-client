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
  final String message;

  const ProjectListError(this.message, {super.name, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [message, name, page, totalPages];
}

class ProjectCreated extends ProjectListLoaded {
  final int projectId;

  const ProjectCreated(super.projects, {required this.projectId, super.name, required super.page, required super.totalPages});
}

class ProjectCreateError extends ProjectListLoaded {
  final String message;

  const ProjectCreateError(super.projects, {super.name, required this.message, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, message, name, page, totalPages];
}

class ProjectFromListDeleted extends ProjectListLoaded {
  const ProjectFromListDeleted(super.projects, {super.name, required super.page, required super.totalPages});
}

class ProjectFromListDeleteError extends ProjectListLoaded {
  final String message;

  const ProjectFromListDeleteError(super.projects, {super.name, required this.message, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, message, name, page, totalPages];
}