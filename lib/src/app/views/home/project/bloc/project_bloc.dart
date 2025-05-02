import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectApi projectApi;

  ProjectBloc(this.projectApi) : super(const ProjectInitial()) {
    on<GetProject>(_onGetProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<ResetProject>(_onResetProject);
  }

  Future<void> _onGetProject(GetProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectLoading());
    try {
      final res = await projectApi.getProject(id: event.id);
      res.fold((left) {
        emit(ProjectError(left.data));
      }, (right) {
        emit(ProjectLoaded(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(UpdateProject event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    try {
      final res = await projectApi.updateProject(newProject: event.newProject);
      res.fold((left) {
        emit(ProjectUpdateError((state as ProjectLoaded).project, data: left.data));
      }, (right) {
        emit(ProjectUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectUpdateError((state as ProjectLoaded).project, data: e.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded || (state as ProjectLoaded).project.id != event.id) return;
    try {
      if (event.refresh) {
        emit(const ProjectInitial());
      } else {
        final res = await projectApi.deleteProject(id: event.id);
        res.fold((left) {
          emit(ProjectDeleteError((state as ProjectLoaded).project, data: left.data));
        }, (right) {
          emit(const ProjectDeleted());
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectDeleteError((state as ProjectLoaded).project, data: e.toString()));
    }
  }

  Future<void> _onResetProject(ResetProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectInitial());
  }
}