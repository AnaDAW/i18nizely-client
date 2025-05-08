import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String button;
  final VoidCallback onPressed;

  const AppConfirmationDialog({super.key, required this.title, required this.description, required this.button, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCardTitle(title: title),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Text(
                description,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20,),
            Divider(color: AppColors.detail,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(text: 'Cancel', onPressed: () => context.pop()),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: AppStyledButton(text: button, onPressed: onPressed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}