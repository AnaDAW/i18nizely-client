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
    on<CreateProjectFromList>(_onCreateProjectFromList);
    on<UpdateProjectFromList>(_onUpdateProjectFromList);
    on<DeleteProjectFromList>(_onDeleteProjectFromList);
  }

  Future<void> _onGetProjects(GetProjects event, Emitter<ProjectListState> emit) async {
    emit(ProjectListLoading(page: event.page, totalPages: state.totalPages));
    try {
      final res = await projectApi.getProjects(name: event.name, page: event.page);
      res.fold((left) {
        emit(ProjectListError(left.message.toString(), page: event.page, totalPages: state.totalPages));
      }, (right) {
        emit(ProjectListLoaded(right, page: event.page, totalPages: state.totalPages));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectListError(e.toString(), page: event.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onCreateProjectFromList(CreateProjectFromList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    if (state.page == state.totalPages) {
      await _onGetProjects(GetProjects(page: state.page), emit);
      return;
    }
  }

  Future<void> _onUpdateProjectFromList(UpdateProjectFromList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    for (Project project in (state as ProjectListLoaded).projects) {
      if (project.id == event.id) {
        await _onGetProjects(GetProjects(page: state.page), emit);
        return;
      }
    }
  }

  Future<void> _onDeleteProjectFromList(DeleteProjectFromList event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    if (event.refresh) {
      for (Project project in (state as ProjectListLoaded).projects) {
        if (project.id != null && project.id! >= event.id) {
          await _onGetProjects(GetProjects(page: state.page), emit);
          return;
        }
      }
    } else {
      try {
        final res = await projectApi.deleteProject(id: event.id);
        await res.fold((left) {
          emit(ProjectListDeleteError((state as ProjectListLoaded).projects, message: left.message.toString(), page: state.page, totalPages: state.totalPages));
        }, (right) async {
          await _onGetProjects(GetProjects(page: state.page), emit);
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        emit(ProjectListDeleteError((state as ProjectListLoaded).projects, message: e.toString(), page: state.page, totalPages: state.totalPages));
      }
    }
  }
}