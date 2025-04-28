import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class CollabProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectApi projectApi;

  CollabProjectListBloc(this.projectApi) : super(const ProjectListInitial(page: 1, totalPages: 1)) {
    on<GetProjects>(_onGetProjects);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
  }

  Future<void> _onGetProjects(GetProjects event, Emitter<ProjectListState> emit) async {
    emit(ProjectListLoading(page: state.page, totalPages: state.totalPages));
    try {
      final res = await projectApi.getCollabProjects(name: event.name, page: event.page);
      res.fold((left) {
        emit(ProjectListError(left.message.toString(), page: state.page, totalPages: state.totalPages));
      }, (right) {
        emit(ProjectListLoaded(right, page: state.page, totalPages: state.totalPages));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProjectListError(e.toString(), page: state.page, totalPages: state.totalPages));
    }
  }

  Future<void> _onUpdateProject(UpdateProject event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    for (Project project in (state as ProjectListLoaded).projects) {
      if (project.id == event.id) {
        await _onGetProjects(GetProjects(page: state.page), emit);
        return;
      }
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectListState> emit) async {
    if (state is! ProjectListLoaded) return;
    for (Project project in (state as ProjectListLoaded).projects) {
      if (project.id != null && project.id! >= event.id) {
        await _onGetProjects(GetProjects(page: state.page), emit);
        return;
      }
    }
  }
}