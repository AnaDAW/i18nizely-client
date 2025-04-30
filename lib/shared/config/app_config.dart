import 'dart:convert';

import 'package:flutter/widgets.dart';

class AppConfig {
  static final baseUrl = 'http://localhost:8000/';
  static late final Map<String, dynamic> languages;

  static Future<void> initLanguages(BuildContext context) async {
    String json = await DefaultAssetBundle.of(context).loadString('assets/languages.json');
    languages = jsonDecode(json);
  }
}