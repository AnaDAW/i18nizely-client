import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:i18nizely/shared/data/remote/dio_network_service.dart';
import 'package:i18nizely/shared/data/remote/network_service.dart';
import 'package:i18nizely/shared/exceptions/dio_network_service.dart';
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

final locator = GetIt.instance;

initInjection() {
  locator.registerLazySingleton<Dio>(() => Dio());
  
  locator<Dio>().interceptors.add(ErrorInterceptor());
  
  locator.registerLazySingleton<NetworkService>(() => DioNetworkService(locator<Dio>()));

  locator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  initToken();

  locator.registerFactory<AuthApi>(() {
    final networkService = locator<NetworkService>();
    final storage = locator<FlutterSecureStorage>();
    return AuthApiDataSource(networkService, storage);
  });

  locator.registerFactory<UserApi>(() {
    final networkService = locator<NetworkService>();
    return UserApiDataSource(networkService);
  });

  locator.registerFactory<ProjectApi>(() {
    final networkService = locator<NetworkService>();
    return ProjectApiDataSource(networkService);
  });

  locator.registerFactory<KeyApi>(() {
    final networkService = locator<NetworkService>();
    return KeyApiDataSource(networkService);
  });

  locator.registerFactory<TranslationApi>(() {
    final networkService = locator<NetworkService>();
    return TranslationApiDataSource(networkService);
  });
}

Future<void> initToken() async {
  var network = locator<NetworkService>();
  var storage = locator<FlutterSecureStorage>();

  if (await storage.containsKey(key: 'token_access')) {
    final String? token = await storage.read(key: 'token_access');
    network.updateHeader({'Authorization': "Bearer $token"});
  }
}