import 'package:flutter/material.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppTitleBar(title: 'Project Overview')
      ],
    );
  }
  
}