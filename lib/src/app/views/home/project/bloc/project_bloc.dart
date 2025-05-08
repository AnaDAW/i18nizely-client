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
    if (state is! ProjectLoaded) return;
    try {
      if (event.id != null) {
        if (event.id == ((state as ProjectLoaded).project.id ?? 0)) emit(const ProjectDeleted());
      } else {
        final res = await projectApi.deleteProject(id: event.id ?? (state as ProjectLoaded).project.id ?? 0);
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

  Future<void> _onAddCollaborator(AddCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    try {
      final res = await projectApi.addCollaborator(projectId: (state as ProjectLoaded).project.id ?? 0, newCollaborator: event.newCollaborator);
      res.fold((left) {
        emit(CollaboratorAddError((state as ProjectLoaded).project, data: left.data));
      }, (right) {
        List<Collaborator> collaborators = List.of((state as ProjectLoaded).project.collaborators ?? []);
        collaborators.add(right);
        emit(ProjectLoaded((state as ProjectLoaded).project));
        emit(CollaboratorAdded((state as ProjectLoaded).project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorAddError((state as ProjectLoaded).project, data: e.toString()));
    }
  }

  Future<void> _onUpdateCollaborator(UpdateCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    try {
      final res = await projectApi.updateCollaborator(projectId: (state as ProjectLoaded).project.id ?? 0, id: event.id, roles: event.roles);
      res.fold((left) {
        emit(CollaboratorUpdateError((state as ProjectLoaded).project, data: left.data));
      }, (right) {
        List<Collaborator> collaborators = List.of((state as ProjectLoaded).project.collaborators ?? []);
        int index = collaborators.indexWhere((collab) => collab.id == event.id);
        collaborators[index] = right;
        emit(ProjectLoaded((state as ProjectLoaded).project));
        emit(CollaboratorUpdated((state as ProjectLoaded).project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorUpdateError((state as ProjectLoaded).project, data: e.toString()));
    }
  }

  Future<void> _onRemoveCollaborator(RemoveCollaborator event, Emitter<ProjectState> emit) async {
    if (state is! ProjectLoaded) return;
    try {
      final res = await projectApi.removeCollaborator(projectId: (state as ProjectLoaded).project.id ?? 0, id: event.id);
      res.fold((left) {
        emit(CollaboratorRemoveError((state as ProjectLoaded).project, data: left.data));
      }, (right) {
        List<Collaborator> collaborators = List.of((state as ProjectLoaded).project.collaborators ?? []);
        collaborators.removeWhere((collab) => collab.id == event.id);
        emit(ProjectLoaded((state as ProjectLoaded).project));
        emit(CollaboratorRemoved((state as ProjectLoaded).project.copyWith(collaborators: collaborators)));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CollaboratorRemoveError((state as ProjectLoaded).project, data: e.toString()));
    }
  }

  Future<void> _onResetProject(ResetProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectInitial());
  }
}