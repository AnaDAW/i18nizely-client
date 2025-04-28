import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectApi projectApi;

  ProjectBloc(this.projectApi) : super(const ProjectInitial()) {
    on<CreateProject>(_onCreateProject);
    on<GetProject>(_onGetProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
  }

  Future<void> _onCreateProject(CreateProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectLoading());
    try {
      final res = await projectApi.createProject(newProject: event.project);
      res.fold((left) {
        emit(ProjectError(left.message.toString()));
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

  Future<void> _onGetProject(GetProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectLoading());
    try {
      final res = await projectApi.getProject(id: event.id);
      res.fold((left) {
        emit(ProjectError(left.message.toString()));
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
        emit(ProjectUpdateError((state as ProjectLoaded).project, message: left.message.toString()));
      }, (right) {
        emit(ProjectUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectUpdateError((state as ProjectLoaded).project, message: e.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    final Project project = (state as ProjectLoaded).project;
    try {
      final res = await projectApi.deleteProject(id: event.id);
      res.fold((left) {
        emit(ProjectDeleteError((state as ProjectLoaded).project, message: left.message.toString()));
      }, (right) { 
        emit(ProjectDeleted());
        if (event.id == project.id) {
          emit(ProjectInitial());
        } else {
          emit(ProjectLoaded(project));
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectDeleteError((state as ProjectLoaded).project, message: e.toString()));
    }
  }
}