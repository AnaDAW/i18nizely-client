import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';
import 'package:i18nizely/src/domain/models/version_model.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';

class TranslationApiDataSource implements TranslationApi {
  final NetworkService networkService;

  const TranslationApiDataSource(this.networkService);

  @override
  Future<Either<AppException, Translation>> createTranslation({required int projectId, required int keyId, required Translation newTranslation}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/$keyId/translations/', data: newTranslation.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Translation translation = Translation.fromJson(response.data);
        return Right(translation);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.createTranslation',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Translation>> updateTranslation({required int projectId, required int keyId, required int id, required String newText}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/$keyId/translations/$id/', data: {'text': newText});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Translation translation = Translation.fromJson(response.data);
        return Right(translation);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.updateTranslation',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Translation>> reviewTranslation({required int projectId, required int keyId, required int id, required bool isReviewed}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/$keyId/translations/$id/review/', data: { 'is_reviewed': isReviewed });
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Translation translation = Translation.fromJson(response.data);
        return Right(translation);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.reviewTranslation',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<Version>>> getVersions({required int projectId, required int keyId, required int translationId}) async {
    try {
      final eitherType = await networkService.get('projects/$projectId/keys/$keyId/translations/$translationId/versions/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<Version> versions = [];
        for (var version in response.data) {
          versions.add(Version.fromJson(version));
        }
        return Right(versions);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.getVersions',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<Comment>>> getComments({required int projectId, required int keyId, required int translationId}) async {
    try {
      final eitherType = await networkService.get('projects/$projectId/keys/$keyId/translations/$translationId/comments/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<Comment> comments = [];
        for (var comment in response.data) {
          comments.add(Comment.fromJson(comment));
        }
        return Right(comments);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.getComments',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Comment>> createComment({required int projectId, required int keyId, required int translationId, required Comment newComment }) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/keys/$keyId/translations/$translationId/comments/', data: newComment.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Comment comment = Comment.fromJson(response.data);
        return Right(comment);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.createComment',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Comment>> updateComment({required int projectId, required int keyId, required int translationId, required Comment newComment}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/keys/$keyId/translations/$translationId/comments/${newComment.id}/', data: newComment.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Comment comment = Comment.fromJson(response.data);
        return Right(comment);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.updateComment',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteComment({required int projectId, required int keyId, required int translationId, required int id}) async {
    try {
      final eitherType = await networkService.delete('projects/$projectId/keys/$keyId/translations/$translationId/comments/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'TranslationApiDataSource.deleteComment',
        ),
      );
    }
  }
}