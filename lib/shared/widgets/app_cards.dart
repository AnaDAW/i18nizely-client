import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';

class AppElevatedCard extends StatelessWidget {
  final Widget child;

  const AppElevatedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ]
      ),
      child: child,
    );
  }
}

class AppCardTitle extends StatelessWidget {
  final String title;

  const AppCardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}