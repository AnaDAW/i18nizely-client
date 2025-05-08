import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/src/app/router/app_router.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/version/bloc/versions_bloc.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initInjection();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('i18nizely');
    setWindowMinSize(const Size(1050, 700));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const I18nizely());
}

class I18nizely extends StatelessWidget {
  const I18nizely({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig.initLanguages(context);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => locator<ProfileBloc>()),
        BlocProvider<ProjectListBloc>(create: (_) => locator<ProjectListBloc>()),
        BlocProvider<CollabProjectListBloc>(create: (_) => locator<CollabProjectListBloc>()),
        BlocProvider<ProjectBloc>(create: (_) => locator<ProjectBloc>()),
        BlocProvider<TranslationsBloc>(create: (_) => locator<TranslationsBloc>()),
        BlocProvider<CommentsBloc>(create: (_) => locator<CommentsBloc>()),
        BlocProvider<VersionBloc>(create: (_) => locator<VersionBloc>()),
      ],
      child: MaterialApp.router(
        title: 'i18nizely',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}