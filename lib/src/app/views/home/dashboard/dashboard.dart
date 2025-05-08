import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_confirmation_dialog.dart';
import 'package:i18nizely/src/app/common/app_list_card.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_event.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/app/views/home/dashboard/dashboard_dialog.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User profile = context.select((ProfileBloc bloc) {
      if (bloc.state is ProfileLoaded) {
        return (bloc.state as ProfileLoaded).profile;
      }
      return User();
    });
    String? name;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(
          title: 'Dashboard',
          hasSearch: true,
          hint: 'Search a project...',
          onSumitSearch: (value) {
            if (value != null && value.isNotEmpty) {
              name = value;
            } else {
              name = null;
            }
            locator<ProjectListBloc>().add(GetProjects(page: 1, name: name));
            locator<CollabProjectListBloc>().add(GetProjects(page: 1, name: name));
          },
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      BlocConsumer<ProjectListBloc, ProjectListState>(
                        listener: (context, state) {
                          if (state is ProjectCreated) {
                            AppSnackBar.showSnackBar(context, text: 'Project created');
                          } else if (state is ProjectCreateError) {
                            AppSnackBar.showSnackBar(context, text: 'Error creating the profile', isError: true);
                          } else if (state is ProjectFromListDeleted) {
                            AppSnackBar.showSnackBar(context, text: 'Project deleted');
                          } else if (state is ProjectFromListDeleteError) {
                            AppSnackBar.showSnackBar(context, text: 'Error deleting the project', isError: true);
                          }
                        },
                        builder: (context, state) {
                          if (state is ProjectListInitial) {
                            locator<ProjectListBloc>().add(GetProjects(page: state.page));
                          }
                          return AppListCard(
                            title: 'My Projects',
                            emptyText: 'No projects created yet.',
                            state: state,
                            changePage: (page) => locator<ProjectListBloc>().add(GetProjects(page: page, name: name)),
                            deleteProject: (id) {
                              showDialog(
                                context: context,
                                builder: (context) => AppConfirmationDialog(
                                  title: 'Delete Project',
                                  description: 'Are you sure you want to delete the project?',
                                  button: 'Delete',
                                  onPressed: () async {
                                    await deleteProject(id);
                                    context.pop();
                                  },
                                ),
                              );
                            },
                          );
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, right: 20),
                        child: AppIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DashboardDialog(profileLang: profile.language ?? 'en'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: BlocConsumer<CollabProjectListBloc, ProjectListState>(
                    listener: (context, state) {
                      if (state is ProjectFromListDeleted) {
                        AppSnackBar.showSnackBar(context, text: 'Project deleted');
                      } else if (state is ProjectFromListDeleteError) {
                        AppSnackBar.showSnackBar(context, text: 'Error deleting the project', isError: true);
                      }
                    },
                    builder: (context, state) {
                      if (state is ProjectListInitial) {
                        locator<CollabProjectListBloc>().add(GetProjects(page: state.page));
                      }
                      return AppListCard(
                        title: 'Shared with me',
                        emptyText: 'No projects shared with me.',
                        state: state,
                        changePage: (page) => locator<CollabProjectListBloc>().add(GetProjects(page: page, name: name)),
                        deleteProject: (id) {
                          showDialog(
                            context: context,
                            builder: (context) => AppConfirmationDialog(
                              title: 'Delete Project',
                              description: 'Are you sure you want to delete the project?',
                              button: 'Delete',
                              onPressed: () => locator<CollabProjectListBloc>().add(DeleteProjectFromList(id)),
                            ),
                          );
                        },
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> deleteProject(int id) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectListBloc>().stream.listen((state) {
      if (state is ProjectFromListDeleted) {
        subscription.cancel();
        locator<ProjectBloc>().add(DeleteProject(id: id));
        completer.complete();
      } else if (state is ProjectFromListDeleteError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<ProjectListBloc>().add(DeleteProjectFromList(id));
    return completer.future;
  }
}