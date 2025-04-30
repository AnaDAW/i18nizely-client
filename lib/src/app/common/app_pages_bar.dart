import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';

class AppPagesBar extends StatelessWidget {
  final int page;
  final int totalPages;
  final void Function(int) changePage;

  const AppPagesBar({super.key, required this.page, required this.totalPages, required this.changePage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.detail, indent: 10, endIndent: 10,),
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconButton(
                  icon: Icons.skip_previous_rounded,
                  onPressed: () => changePage(1),
                  enable: page != 1
              ),
              buildIconButton(
                  icon: Icons.navigate_before_rounded,
                  onPressed: () => changePage(page - 1),
                  enable: page != 1
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('$page of $totalPages', style: TextStyle(color: Colors.black45),),
              ),
              buildIconButton(
                  icon: Icons.navigate_next_rounded,
                  onPressed: () => changePage(page + 1),
                  enable: page != totalPages
              ),
              buildIconButton(
                  icon: Icons.skip_next_rounded,
                  onPressed: () => changePage(totalPages),
                  enable: page != totalPages
              ),
            ],
          ),
        ),
      ],
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