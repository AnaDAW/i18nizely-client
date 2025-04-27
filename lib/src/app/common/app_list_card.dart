import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class AppListCard extends StatelessWidget {
  final List<Project> projects;
  final String title;
  final String emptyText;
  final int actualPage;
  final int totalPages;
  final Future<void> Function(int) changePage;
  
  const AppListCard({
    super.key, required this.projects, required this.title, required this.emptyText, required this.actualPage,
    required this.totalPages, required this.changePage
  });

  @override
  Widget build(BuildContext context) {
    return AppElevatedCard(
      child: Column(
        children: [
          AppCardTitle(title: title),
          Expanded(
            child: projects.isEmpty ? Center(
              child: Text(
                emptyText,
                style: TextStyle(color: Colors.black45),
              ),
            ) : SingleChildScrollView(),
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
                  enable: actualPage != 1
                ),
                buildIconButton(
                  icon: Icons.navigate_before_rounded,
                  onPressed: () => changePage(actualPage - 1),
                  enable: actualPage != 1
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('$actualPage of $totalPages', style: TextStyle(color: Colors.black45),),
                ),
                buildIconButton(
                  icon: Icons.navigate_next_rounded,
                  onPressed: () => changePage(actualPage + 1),
                  enable: actualPage != totalPages
                ),
                buildIconButton(
                  icon: Icons.skip_next_rounded,
                  onPressed: () => changePage(totalPages),
                  enable: actualPage != totalPages
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
}