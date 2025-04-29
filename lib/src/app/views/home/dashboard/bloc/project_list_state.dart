import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class ProjectListState extends Equatable {
  final int page;
  final int totalPages;

  const ProjectListState({required this.page, required this.totalPages});

  @override
  List<Object?> get props => [page, totalPages];
}

class ProjectListInitial extends ProjectListState {
  const ProjectListInitial({super.page = 1, super.totalPages = 1});
}

class ProjectListLoading extends ProjectListState {
  const ProjectListLoading({required super.page, required super.totalPages});
}

class ProjectListLoaded extends ProjectListState {
  final List<Project> projects;

  const ProjectListLoaded(this.projects, {required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, page, totalPages];
}

class ProjectListError extends ProjectListState {
  final String message;

  const ProjectListError(this.message, {required super.page, required super.totalPages});

  @override
  List<Object?> get props => [message, page, totalPages];
}

class ProjectListDeleteError extends ProjectListLoaded {
  final String message;

  const ProjectListDeleteError(super.projects, {required this.message, required super.page, required super.totalPages});

  @override
  List<Object?> get props => [projects, message, page, totalPages];
}