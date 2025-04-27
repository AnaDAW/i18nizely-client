import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';

class TranslationsScreen extends StatelessWidget {
  const TranslationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Translations'),
            SizedBox(
              width: 600,
              child: AppSearchTextField(hint: 'Search something', onSubmit: (_) {},),
              ),
            Text('User'),
          ],
        ),
      ],
    );
  }
  
}