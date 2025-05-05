import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final bool hasClose;

  const AppCardTitle({super.key, required this.title, this.hasClose = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (hasClose)
            IconButton(onPressed: () => context.pop(), icon: Icon(Icons.close_rounded, color: Colors.white,))
        ],
      ),
    );
  }
}