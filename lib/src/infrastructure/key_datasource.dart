import 'dart:io';

import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';

class KeyApiDataSource implements KeyApi {
  final NetworkService networkService;

  const KeyApiDataSource(this.networkService);

  @override
  Future<Either<AppException, List<Key>>> getKeys({required int projectId, int page = 1}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/', data: {'page': page});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<Key> keys = [];
        for (var key in response.data) {
          keys.add(Key.fromJson(key));
        }
        return Right(keys);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.getKeys',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Key>> createKey({required int projectId, required Key newKey}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/', data: newKey.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
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
      }, (response) async {
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
      }, (response) async {
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