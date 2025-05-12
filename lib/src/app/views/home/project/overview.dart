import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/notifications/notifications.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/domain/models/language_model.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AppTitleBar(title: 'Project Overview'),
            Expanded(
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoading) {
                    return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
                  } else if (state is ProjectError) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_rounded, color: Colors.red.shade400,),
                          SizedBox(width: 5,),
                          Text(
                            'Error getting the project.',
                            style: TextStyle(color: Colors.red.shade400),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProjectLoaded) {
                    final Map<String, dynamic> languageCodes = AppConfig.languages;
                    final List<Language> languages = state.project.languages ?? [];
                    final int totalKeys = languages.where((lang) => lang.code == state.project.mainLanguage).first.translationCount;
                    final int totalTranslations = languages.fold(0, (previousValue, element) => previousValue + element.translationCount);
                    final int totalReviewed = languages.fold(0, (previousValue, element) => previousValue + element.reviewedCount);
                    final double translationProgress = totalKeys == 0 ? 0 : (totalTranslations / languages.length) / totalKeys;
                    final double reviewedProgress = totalKeys == 0 ? 0 : (totalReviewed / languages.length) / totalKeys;
              
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppElevatedCard(
                              padding: EdgeInsets.all(40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.project.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        if (state.project.description != null && state.project.description!.isNotEmpty)
                                          Text(state.project.description!)
                                        else
                                          Text(
                                            'No description.',
                                            style: TextStyle(color: Colors.black45),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 40,),
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 15,
                                            color: AppColors.primary,
                                            value: translationProgress,
                                            backgroundColor: Colors.black12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 15,
                                            color: AppColors.secondary,
                                            value: reviewedProgress,
                                          ),
                                        ),
                                        totalKeys == 0 ? Text(
                                            'No translations yet.',
                                            style: TextStyle(color: Colors.black45, fontSize: 16),
                                          ) : Column(
                                            children: [
                                              Text(
                                                'Translated:',
                                                style: TextStyle(color: Colors.black45, fontSize: 20),
                                              ),
                                              Text(
                                                '${(translationProgress / totalKeys * 100).toStringAsFixed(0)} %',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              SizedBox(width: 150, child: Divider(color: AppColors.detail,)),
                                              Text(
                                                'Reviewed:',
                                                style: TextStyle(color: Colors.black45, fontSize: 20),
                                              ),
                                              Text(
                                                '${(reviewedProgress / totalKeys * 100).toStringAsFixed(0)} %',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Wrap(
                              children: [
                                for (Language language in languages)
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: AppElevatedCard(
                                      child: SizedBox(
                                        width: 230,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                gradient: AppColors.gradient,
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                                              ),
                                              child: Text(
                                                languageCodes[language.code],
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(40),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 150,
                                                    width: 150,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 15,
                                                      color: AppColors.primary,
                                                      value: totalKeys == 0 ? 0 : language.translationCount / totalKeys,
                                                      backgroundColor: Colors.black12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 150,
                                                    width: 150,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 15,
                                                      color: AppColors.secondary,
                                                      value: totalKeys == 0 ? 0 : language.reviewedCount / totalKeys,
                                                    ),
                                                  ),
                                                  totalKeys == 0 ? Text(
                                                    'No translations yet.',
                                                    style: TextStyle(color: Colors.black45, fontSize: 12),
                                                  ) : Column(
                                                    children: [
                                                      Text('Translated:', style: TextStyle(color: Colors.black45),),
                                                      Text('${(language.translationCount / totalKeys * 100).toStringAsFixed(0)} %'),
                                                      SizedBox(width: 100, child: Divider(color: AppColors.detail,)),
                                                      Text('Reviewed:', style: TextStyle(color: Colors.black45),),
                                                      Text('${(language.reviewedCount / totalKeys * 100).toStringAsFixed(0)} %'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
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
                          'Project not found.',
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
        NotificationsTab(),
      ],
    );
  }
}