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
    try {
      final res = await projectApi.createProject(newProject: event.project, languages: event.languages);
      await res.fold((left) {
        emit(ProjectCreateError((state as ProjectListLoaded).projects, name: state.name, data: left.data, page: state.page, totalPages: state.totalPages));
      }, (right) async {
        emit(ProjectCreated((state as ProjectListLoaded).projects, projectId: right.id ?? 0, name: state.name, page: state.page, totalPages: state.totalPages));
        if (state.page == state.totalPages) {
          await _onGetProjects(GetProjects(name: state.name, page: state.page), emit);
          return;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectCreateError((state as ProjectListLoaded).projects, name: state.name, data: e.toString(), page: state.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onUpdateProjectList(UpdateProjectList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    for (Project project in (state as ProjectListLoaded).projects) {
      if (project.id == event.id) {
        await _onGetProjects(GetProjects(name: state.name, page: state.page), emit);
        return;
      }
    }
  }

  Future<void> _onDeleteProjectFromList(DeleteProjectFromList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    if (event.refresh) {
      for (Project project in (state as ProjectListLoaded).projects) {
        if (project.id != null && project.id! >= event.id) {
          await _onGetProjects(GetProjects(name: state.name, page: state.page), emit);
          return;
        }
      }
    } else {
      try {
        final res = await projectApi.deleteProject(id: event.id);
        await res.fold((left) {
          emit(ProjectFromListDeleteError((state as ProjectListLoaded).projects, name: state.name, data: left.data, page: state.page, totalPages: state.totalPages));
        }, (right) async {
          emit(ProjectFromListDeleted((state as ProjectListLoaded). projects, name: state.name, page: state.page, totalPages: state.totalPages));
          await _onGetProjects(GetProjects(name: state.name, page: state.page), emit);
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        emit(ProjectFromListDeleteError((state as ProjectListLoaded).projects, name: state.name, data: e.toString(), page: state.page, totalPages: state.totalPages));
      }
    }
  }

  Future<void> _onResetProjectList(ResetProjectList event, Emitter<ProjectListState> emit) async {
    emit(const ProjectListInitial());
  }
}