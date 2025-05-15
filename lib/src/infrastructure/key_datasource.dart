import 'dart:io';

import 'package:dio/dio.dart';
import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/services/key_api.dart';

class KeyApiDataSource implements KeyApi {
  final NetworkService networkService;

  const KeyApiDataSource(this.networkService);

  @override
  Future<Either<AppException, Map<String,dynamic>>> getKeys({required int projectId, int page = 1, String? name}) async {
    try {
      final Map<String, dynamic> queryParameters = {'page': page};
      if (name != null) queryParameters['name'] = name;

      final eitherType = await networkService.get('projects/$projectId/keys/', queryParameters: queryParameters);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final List<TransKey> keys = [];
        for (var key in response.data['results'] ?? []) {
          keys.add(TransKey.fromJson(key));
        }

        int totalPages = ((response.data['count'] ?? 1) / 10).ceil();

        Map<String, dynamic> res = {'totalPages': totalPages == 0 ? 1 : totalPages, 'keys': keys};
        return Right(res);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.getKeys',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, TransKey>> createKey({required int projectId, required TransKey newKey, required String translation}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/', data: {...newKey.toQueryMap(), 'translation': translation});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final TransKey key = TransKey.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.createKey',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, TransKey>> updateKey({required int projectId, required TransKey newKey}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/${newKey.id}/', data: newKey.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final TransKey key = TransKey.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.updateKey',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, TransKey>> addImage({required int projectId, required int id, required String imagePath}) async {
    try {
      final eitherType = await networkService.updateFiles('projects/$projectId/keys/$id/', files: {'image': imagePath});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final TransKey key = TransKey.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.addImage',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, TransKey>> removeImage({required int projectId, required int id}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/$id/', data: {'image': null});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final TransKey key = TransKey.fromJson(response.data);
        return Right(key);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.removeImage',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteKey({required int projectId, required int id}) async {
    try {
      final eitherType = await networkService.delete('projects/$projectId/keys/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.deleteKey',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<TransKey>>> importKeys({required int projectId, required Map<String, String> files}) async {
    try {
      final eitherType = await networkService.uploadFiles('projects/$projectId/keys/import/', files: files);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) {
        final List<TransKey> keys = [];
        for (var key in response.data) {
          keys.add(TransKey.fromJson(key));
        }
        return Right(keys);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.importKeys',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> exportKeys({required int projectId, required String filePath, List<String>? fileTypes, List<String>? languages, bool onlyReviewed = false}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (fileTypes != null && fileTypes.isNotEmpty) queryParameters['file_types'] = fileTypes;
      if (languages != null && languages.isNotEmpty) queryParameters['languages'] = languages;
      queryParameters['only_reviewed'] = onlyReviewed;

      BaseOptions newOptions = networkService.dioBaseOptions;
      newOptions.headers = networkService.headers;
      newOptions.responseType = ResponseType.bytes;
      networkService.updateBaseOptions(newOptions);

      final eitherType = await networkService.get('projects/$projectId/keys/export/', queryParameters: queryParameters);

      BaseOptions oldOptions = networkService.dioBaseOptions;
      oldOptions.headers = networkService.headers;
      networkService.updateBaseOptions(oldOptions);

      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        if (response.statusCode != 204) {
          File file = File(filePath);
          await file.writeAsBytes(response.data);
        }
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'KeyApiDataSource.exportKeys',
        ),
      );
    }
  }
}