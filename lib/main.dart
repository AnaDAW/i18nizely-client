import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/src/app/router/app_router.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initInjection();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('i18nizely');
    setWindowMinSize(const Size(1000, 650));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const I18nizely());
}

class I18nizely extends StatelessWidget {
  const I18nizely({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig.initLanguages(context);
    
    return MaterialApp.router(
      title: 'i18nizely',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}