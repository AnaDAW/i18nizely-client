import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectApi projectApi;

  ProjectBloc(this.projectApi) : super(const ProjectInitial()) {
    on<GetProject>(_onGetProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<AddCollaborator>(_onAddCollaborator);
    on<UpdateCollaborator>(_onUpdateCollaborator);
    on<RemoveCollaborator>(_onRemoveCollaborator);
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
    ProjectLoaded loadedState = state as ProjectLoaded;
    try {
      final res = await projectApi.updateProject(newProject: event.newProject, languages: event.languages);
      res.fold((left) {
        emit(ProjectUpdateError(loadedState.project, data: left.data));
      }, (right) {
        emit(ProjectUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectUpdateError(loadedState.project, data: e.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    ProjectLoaded loadedState = state as ProjectLoaded;
    try {
      if (event.id != null) {
        if (event.id == (loadedState.project.id ?? 0)) emit(const ProjectDeleted());
      } else {
        final res = await projectApi.deleteProject(id: event.id ?? loadedState.project.id ?? 0);
        res.fold((left) {
          emit(ProjectDeleteError(loadedState.project, data: left.data));
        }, (right) {
          emit(const ProjectDeleted());
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectDeleteError(loadedState.project, data: e.toString()));
    }
  }

  Future<void> _onAddCollaborator(AddCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    ProjectLoaded loadedState = state as ProjectLoaded;
    try {
      final res = await projectApi.addCollaborator(projectId: loadedState.project.id ?? 0, newCollaborator: event.newCollaborator);
      res.fold((left) {
        emit(CollaboratorAddError(loadedState.project, data: left.data));
      }, (right) {
        final List<Collaborator> collaborators = List.of(loadedState.project.collaborators ?? []);
        collaborators.add(right);
        //emit(ProjectLoaded(loadedState.project));
        emit(CollaboratorAdded(loadedState.project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorAddError(loadedState.project, data: e.toString()));
    }
  }

  Future<void> _onUpdateCollaborator(UpdateCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    ProjectLoaded loadedState = state as ProjectLoaded;
    try {
      final res = await projectApi.updateCollaborator(projectId: loadedState.project.id ?? 0, id: event.id, roles: event.roles);
      res.fold((left) {
        emit(CollaboratorUpdateError(loadedState.project, data: left.data));
      }, (right) {
        final List<Collaborator> collaborators = List.of(loadedState.project.collaborators ?? []);
        final int index = collaborators.indexWhere((collab) => collab.id == event.id);
        if (index != -1) collaborators[index] = right;
        //emit(ProjectLoaded(loadedState.project));
        emit(CollaboratorUpdated(loadedState.project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorUpdateError(loadedState.project, data: e.toString()));
    }
  }

  Future<void> _onRemoveCollaborator(RemoveCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    ProjectLoaded loadedState = state as ProjectLoaded;
    try {
      final res = await projectApi.removeCollaborator(projectId: loadedState.project.id ?? 0, id: event.id);
      res.fold((left) {
        emit(CollaboratorRemoveError(loadedState.project, data: left.data));
      }, (right) {
        final List<Collaborator> collaborators = List.of(loadedState.project.collaborators ?? []);
        collaborators.removeWhere((collab) => collab.id == event.id);
        //emit(ProjectLoaded(loadedState.project));
        emit(CollaboratorRemoved(loadedState.project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorRemoveError(loadedState.project, data: e.toString()));
    }
  }

  Future<void> _onResetProject(ResetProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectInitial());
  }
}