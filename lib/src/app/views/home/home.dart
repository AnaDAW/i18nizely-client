import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_drawer.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';

import 'account/bloc/profile_event.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileUpdated) {
            AppSnackBar.showSnackBar(context, text: 'Profile updated');
          } else if (state is ProfileUpdateError) {
            AppSnackBar.showSnackBar(context, text: 'Error updating the profile', isError: true);
          } else if (state is ProfileDeleteError) {
            AppSnackBar.showSnackBar(context, text: 'Error deleting the profile', isError: true);
          } else if (state is ProfileDeleted) {
            AppSnackBar.showSnackBar(context, text: 'Profile deleted');
            await locator<AuthApi>().logout();
            context.go('/login');
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial) {
            locator<ProfileBloc>().add(GetProfile());
          } else if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
          } else if (state is ProfileError) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_rounded, color: Colors.red.shade400,),
                  SizedBox(width: 5,),
                  Text(
                    'Error getting the profile.',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            return Container(
              color: Colors.white,
              child: Row(
                children: [
                  AppDrawer(profile: state.profile),
                  Expanded(
                    child: BlocConsumer<TranslationsBloc, TranslationsState>(
                      listenWhen: (previous, current) {
                        return current is KeyImported || current is KeyImportError || current is KeyExported || current is KeyExportError;
                      },
                      listener: (context, state) {
                        if (state is KeyImported) {
                          AppSnackBar.showSnackBar(context, text: 'Files imported');
                        } else if (state is KeyImportError) {
                          AppSnackBar.showSnackBar(context, text: state.data['detail'] ?? 'Error importing files', isError: true);
                        } else if (state is KeyExported) {
                          AppSnackBar.showSnackBar(context, text: 'Project exported');
                        } else if (state is KeyExportError) {
                          AppSnackBar.showSnackBar(context, text: state.data['detail'] ?? 'Error exporting project', isError: true);
                        }
                      },
                      buildWhen: (previous, current) {
                        return current is KeyImporting || current is KeyExporting || current is KeyImported ||
                        current is KeyImportError || current is KeyExported || current is KeyExportError;
                      },
                      builder: (context, state) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            child,
                            if (state is KeyImporting || state is KeyExporting)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
                                child: AppElevatedCard(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: AppColors.detail,),
                                      SizedBox(width: 20,),
                                      Text(
                                        state is KeyImporting ? 'Importing files...' : 'Exporting files...',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_rounded, color: Colors.red.shade400,),
                SizedBox(width: 5,),
                Text(
                  'Profile not found.',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}