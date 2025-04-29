import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';

class TranslationsScreen extends StatelessWidget {
  const TranslationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Project project = context.select((ProjectBloc bloc) => (bloc.state as ProjectLoaded).project);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10,),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Text(
                'Translations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
              ),
              Center(
                child: SizedBox(
                  width: 500,
                  child: AppSearchTextField(
                    hint: 'Search a key...',
                    onSubmit: (value) {
                      final name = value.isNotEmpty ? value : null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<TranslationsBloc, TranslationsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is TranslationsLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.detail,),
                );
              } else if (state is TranslationsError) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_rounded, color: Colors.red.shade400,),
                      SizedBox(width: 5,),
                      Text(
                        'Error getting the translations.',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                );
              } else if (state is TranslationsLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 75,
                            child: Checkbox(value: false, onChanged: (_) {}),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text('Keys'),
                          ),
                          for (String lang in project.languages!)
                            SizedBox(
                              width: 200,
                              child: Text(lang),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 20),
                            child: AppIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Container(),
                                );
                              },
                            ),
                          ),
                          state.keys.isEmpty ? Center(
                            child: Text(
                              'There are no translations yet.',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ) : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ListView.builder(
                              itemCount: state.keys.length,
                              itemBuilder: (context, index) {
                                return Row();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppColors.detail, indent: 10, endIndent: 10,),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildIconButton(
                              icon: Icons.skip_previous_rounded,
                              onPressed: () => locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: 1)),
                              enable: state.page != 1
                          ),
                          buildIconButton(
                              icon: Icons.navigate_before_rounded,
                              onPressed: () => locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: state.page - 1)),
                              enable: state.page != 1
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text('${state.page} of ${state.totalPages}', style: TextStyle(color: Colors.black45),),
                          ),
                          buildIconButton(
                              icon: Icons.navigate_next_rounded,
                              onPressed: () => locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: state.page + 1)),
                              enable: state.page != state.totalPages
                          ),
                          buildIconButton(
                              icon: Icons.skip_next_rounded,
                              onPressed: () => locator<TranslationsBloc>().add(GetTranslations(projectId: project.id ?? 0, page: state.totalPages)),
                              enable: state.page != state.totalPages
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }
          ),
        ),
      ],
    );
  }

  Widget buildIconButton({required IconData icon, required VoidCallback onPressed, required bool enable}) {
    return IconButton(
      onPressed: enable ? onPressed : null,
      icon: Icon(
        icon,
        color: enable ? Colors.black45 : Colors.black12,
      ),
    );
  }
}