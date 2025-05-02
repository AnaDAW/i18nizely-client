import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:i18nizely/shared/domain/services/dio_network_service.dart';
import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/dio_network_exception.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/collab_project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/dashboard/bloc/project_list_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';
import 'package:i18nizely/src/infrastructure/auth_datasource.dart';
import 'package:i18nizely/src/infrastructure/key_datasource.dart';
import 'package:i18nizely/src/infrastructure/project_datasource.dart';
import 'package:i18nizely/src/infrastructure/translation_datasource.dart';
import 'package:i18nizely/src/infrastructure/user_datasource.dart';

import '../app/views/home/translations/bloc/translations_bloc.dart';

final locator = GetIt.instance;

void initInjection() {
  locator.registerLazySingleton<Dio>(() => Dio());
  
  locator<Dio>().interceptors.add(ErrorInterceptor());
  
  locator.registerLazySingleton<NetworkService>(() => DioNetworkService(locator<Dio>()));

  locator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  initToken();

  locator.registerLazySingleton<AuthApi>(() => AuthApiDataSource(locator<NetworkService>(), locator<FlutterSecureStorage>()));

  locator.registerLazySingleton<UserApi>(() => UserApiDataSource(locator<NetworkService>()));

  locator.registerLazySingleton<ProjectApi>(() => ProjectApiDataSource(locator<NetworkService>()));

  locator.registerLazySingleton<KeyApi>(() => KeyApiDataSource(locator<NetworkService>()));

  locator.registerLazySingleton<TranslationApi>(() => TranslationApiDataSource(locator<NetworkService>()));

  locator.registerLazySingleton<ProfileBloc>(() => ProfileBloc(locator<UserApi>()));
  
  locator.registerLazySingleton<ProjectBloc>(() => ProjectBloc(locator<ProjectApi>()));

  locator.registerLazySingleton<ProjectListBloc>(() => ProjectListBloc(locator<ProjectApi>()));

  locator.registerLazySingleton<CollabProjectListBloc>(() => CollabProjectListBloc(locator<ProjectApi>()));

  locator.registerLazySingleton<TranslationsBloc>(() => TranslationsBloc(locator<KeyApi>(), locator<TranslationApi>()));
}

Future<void> initToken() async {
  var storage = locator<FlutterSecureStorage>();

  if (await storage.containsKey(key: 'token_access')) {
    final String? token = await storage.read(key: 'token_access');
    locator<NetworkService>().updateHeader({'Authorization': "Bearer $token"});
  }
}