import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';

import 'account/bloc/profile_event.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => locator<ProfileBloc>()..add(GetProfile())),
        BlocProvider<ProjectListBloc>(create: (_) => locator<ProjectListBloc>()),
        BlocProvider<CollabProjectListBloc>(create: (_) => locator<CollabProjectListBloc>()),
        BlocProvider<ProjectBloc>(create: (_) => locator<ProjectBloc>()),
        BlocProvider<TranslationsBloc>(create: (_) => locator<TranslationsBloc>()),
      ],
      child: Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated'), backgroundColor: Colors.green,));
            } else if (state is ProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating the profile'), backgroundColor: Colors.red,));
            } else if (state is ProfileDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting the profile'), backgroundColor: Colors.red,));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
            } else if (state is ProfileError) {
              return Center(child: Text(state.message),);
            } else if (state is ProfileLoaded) {
              return Container(
                color: Colors.white,
                child: Row(
                  children: [
                    AppDrawer(profile: state.profile),
                    Expanded(child: child,),
                  ],
                ),
              );
            }
            return Center(child: Text('Profile not found.'),);
          },
        ),
      ),
    );
  }
}