import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i18nizely/shared/data/remote/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/services/auth_api.dart';

class AuthApiDataSource implements AuthApi {
  final NetworkService networkService;
  final FlutterSecureStorage storage;

  const AuthApiDataSource(this.networkService, this.storage);

  @override
  Future<Either<AppException, void>> login({required String email, required String password}) async {
    try {
      final eitherType = await networkService.post('auth/login/', data: { 'email': email, 'password': password });
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get token.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'AuthApiDataSource.login',
            ),
          );
        }

        final String tokenAccess = response.data['access'];
        final String tokenRefresh = response.data['refresh'];

        await storage.write(key: 'token_access', value: tokenAccess);
        await storage.write(key: 'token_refresh', value: tokenRefresh);

        networkService.updateHeader({'Authorization': "Bearer $tokenAccess"});
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'AuthApiDataSource.login',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> refresh() async {
    try {
      final String? tokenRefresh = await storage.read(key: 'token_refresh');

      if (tokenRefresh == null || tokenRefresh.isEmpty) {
        return Left(AppException(
          message: 'Failed to get refresh token.',
          statusCode: 500,
          identifier: 'AuthApiDataSource.refresh',
        ));
      }

      final eitherType = await networkService.post('auth/refresh/', data: { 'refresh': tokenRefresh });
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          await logout();
          return Left(
            AppException(
              message: 'Failed to refresh token.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'AuthApiDataSource.refresh',
            ),
          );
        }

        final String tokenAccess = response.data['access'];
        await storage.write(key: 'token_access', value: tokenAccess);

        networkService.updateHeader({'Authorization': "Bearer $tokenAccess"});
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'AuthApiDataSource.refresh',
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'token_access');
    await storage.delete(key: 'token_refresh');
    networkService.headers.remove('Authorization');
  }
  
  @override
  Future<bool> isLogged() async {
    return await storage.containsKey(key: 'token_access');
  }
}