import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectApi projectApi;

  ProjectListBloc(this.projectApi) : super(const ProjectListInitial(page: 1, totalPages: 1)) {
    on<GetProjects>(_onGetProjects);
    on<CreateProject>(_onCreateProject);
    on<UpdateProjectList>(_onUpdateProjectList);
    on<DeleteProjectFromList>(_onDeleteProjectFromList);
    on<ResetProjectList>(_onResetProjectList);
  }

  Future<void> _onGetProjects(GetProjects event, Emitter<ProjectListState> emit) async {
    emit(ProjectListLoading(name: event.name, page: event.page, totalPages: state.totalPages));
    try {
      final res = await projectApi.getProjects(name: event.name, page: event.page);
      res.fold((left) {
        emit(ProjectListError(left.data, name: event.name, page: event.page, totalPages: state.totalPages));
      }, (right) {
        emit(ProjectListLoaded(right['projects'] ?? [], name: event.name, page: event.page, totalPages: right['totalPages'] ?? 1));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectListError(e.toString(), name: event.name, page: event.page, totalPages: state.totalPages));
    }
  }
  
  Future<void> _onCreateProject(CreateProject event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    ProjectListLoaded loadedState = state as ProjectListLoaded;
    try {
      final res = await projectApi.createProject(newProject: event.project, languages: event.languages);
      await res.fold((left) {
        emit(ProjectCreateError(loadedState.projects, name: state.name, data: left.data, page: state.page, totalPages: state.totalPages));
      }, (right) async {
        int totalPages = state.totalPages;
        final List<Project> projects = List.of(loadedState.projects);

        if (state.page == state.totalPages && loadedState.projects.length == 10) {
          totalPages++;
        } else if (state.page == state.totalPages && loadedState.projects.length < 10) {
          projects.add(right);
        }

        emit(ProjectCreated(projects, projectId: right.id ?? 0, name: state.name, page: state.page, totalPages: totalPages));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectCreateError(loadedState.projects, name: state.name, data: e.toString(), page: state.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onUpdateProjectList(UpdateProjectList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    ProjectListLoaded loadedState = state as ProjectListLoaded;

    final List<Project> projects = List.of(loadedState.projects);
    final int index = projects.indexWhere((project) => project.id == event.project.id);
    if (index != -1) projects[index] = event.project;
    emit(ProjectListLoaded(projects, page: state.page, totalPages: state.totalPages));
  }

  Future<void> _onDeleteProjectFromList(DeleteProjectFromList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    ProjectListLoaded loadedState = state as ProjectListLoaded;
    if (event.refresh) {
      final List<Project> projects = List.of(loadedState.projects);
      projects.removeWhere((project) => project.id == event.id);

      emit(ProjectListLoaded(projects, page: state.page, totalPages: state.totalPages));
      if (projects.isEmpty && state.page > 1) {
        await _onGetProjects(GetProjects(name: state.name, page: state.totalPages - 1), emit);
      }
    } else {
      try {
        final res = await projectApi.deleteProject(id: event.id);
        await res.fold((left) {
          emit(ProjectFromListDeleteError(loadedState.projects, name: state.name, data: left.data, page: state.page, totalPages: state.totalPages));
        }, (right) async {
          final List<Project> projects = List.of(loadedState.projects);
          projects.removeWhere((project) => project.id == event.id);

          emit(ProjectFromListDeleted(projects, name: state.name, page: state.page, totalPages: state.totalPages));
          if (projects.isEmpty && state.page > 1) {
            await _onGetProjects(GetProjects(name: state.name, page: state.totalPages - 1), emit);
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        emit(ProjectFromListDeleteError(loadedState.projects, name: state.name, data: e.toString(), page: state.page, totalPages: state.totalPages));
      }
    }
  }

  Future<void> _onResetProjectList(ResetProjectList event, Emitter<ProjectListState> emit) async {
    emit(const ProjectListInitial());
  }
}