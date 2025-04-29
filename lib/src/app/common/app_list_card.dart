import 'package:flutter/material.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_state.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class AppListCard extends StatelessWidget {
  final String title;
  final String emptyText;
  final ProjectListState state;
  final void Function(int) changePage;
  
  const AppListCard({super.key, required this.title, required this.emptyText, required this.state, required this.changePage});

  @override
  Widget build(BuildContext context) {
    return AppElevatedCard(
      child: Column(
        children: [
          AppCardTitle(title: title),
          Expanded(
            child: state is ProjectListLoading ?Center(
                child: CircularProgressIndicator(color: AppColors.detail,),
              ) :
              state is ProjectListError ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_rounded, color: Colors.red.shade400,),
                    SizedBox(width: 5,),
                    Text(
                      'Error getting the projects.',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ],
                ),
              ) : 
              state is ProjectListLoaded ?
                (state as ProjectListLoaded).projects.isEmpty ? Center(
                  child: Text(
                    emptyText,
                    style: TextStyle(color: Colors.black45),
                  ),
                ) : ListView.builder(
                  itemCount: (state as ProjectListLoaded).projects.length,
                  itemBuilder: (context, index) {
                    return buildListItem((state as ProjectListLoaded).projects[index], context);
                  },
                )
              : Container(),
          ),
          Divider(color: AppColors.detail, indent: 10, endIndent: 10,),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIconButton(
                  icon: Icons.skip_previous_rounded,
                  onPressed: () => changePage(1),
                  enable: state.page != 1
                ),
                buildIconButton(
                  icon: Icons.navigate_before_rounded,
                  onPressed: () => changePage(state.page - 1),
                  enable: state.page != 1
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('${state.page} of ${state.totalPages}', style: TextStyle(color: Colors.black45),),
                ),
                buildIconButton(
                  icon: Icons.navigate_next_rounded,
                  onPressed: () => changePage(state.page + 1),
                  enable: state.page != state.totalPages
                ),
                buildIconButton(
                  icon: Icons.skip_next_rounded,
                  onPressed: () => changePage(state.totalPages),
                  enable: state.page != state.totalPages
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({required IconData icon, required VoidCallback onPressed, required bool enable}) {
    return IconButton(
      onPressed: enable ? onPressed : null,
      icon: Icon(
        icon,
        color: enable ? Colors.black45 : Colors.black12,
      ),
    );
  }

  Widget buildListItem(Project project, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(project.name ?? ''),
          subtitle: Text(
            'by ${project.createdBy?.firstName} ${project.createdBy?.lastName}',
            style: TextStyle(color: Colors.black45),
          ),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete_rounded, color: Colors.red.shade400,)),
          onTap: () => locator<ProjectBloc>().add(GetProject(project.id ?? 0)),
        ),
        Divider(color: Colors.black45, indent: 10, endIndent: 10,)
      ],
    );
  }
}