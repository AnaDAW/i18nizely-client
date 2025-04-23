import 'dart:io';

import 'package:i18nizely/shared/data/remote/network_service.dart';
import 'package:i18nizely/shared/exception/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/model/key_model.dart';
import 'package:i18nizely/src/domain/service/key_api.dart';

class KeyApiDataSource implements KeyApi {
  final NetworkService networkService;

  const KeyApiDataSource(this.networkService);

  @override
  Future<Either<AppException, Key>> createKey({required int projectId, required Key newKey}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/', data: newKey.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 201) {
          return Left(
            AppException(
              message: 'Failed to create key.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'KeyApiDataSource.createKey',
            ),
          );
        }

        final Key key = Key.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.createKey',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Key>> updateKey({required int projectId, required Key newKey}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/${newKey.id}/', data: newKey.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to update key.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'KeyApiDataSource.updateKey',
            ),
          );
        }

        final Key key = Key.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.updateKey',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Key>> addImage({required int projectId, required int id, required File image}) async {
    // TODO: implement addImage
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, void>> deleteKey({required int projectId, required int id}) async {
    try {
      final eitherType = await networkService.delete('projects/$projectId/keys/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to delete key.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'KeyApiDataSource.deleteKey',
            ),
          );
        }
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.deleteKey',
        ),
      );
    }
  }
}