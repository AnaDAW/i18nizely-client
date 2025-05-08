import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';
import 'package:i18nizely/src/domain/models/version_model.dart';

abstract class TranslationApi {
  Future<Either<AppException, Translation>> createTranslation({required int projectId, required int keyId, required Translation newTranslation});
  
  Future<Either<AppException, Translation>> updateTranslation({required int projectId, required int keyId, required int id, required String newText});
  
  Future<Either<AppException, Translation>> reviewTranslation({required int projectId, required int keyId, required int id, required bool isReviewed});
  
  Future<Either<AppException, List<Version>>> getVersions({required int projectId, required int keyId, required int translationId});
  
  Future<Either<AppException, List<Comment>>> getComments({required int projectId, required int keyId, required int translationId});
  
  Future<Either<AppException, Comment>> createComment({required int projectId, required int keyId, required int translationId, required Comment newComment});
  
  Future<Either<AppException, Comment>> updateComment({required int projectId, required int keyId, required int translationId, required Comment newComment});
  
  Future<Either<AppException, void>> deleteComment({required int projectId, required int keyId, required int translationId, required int id});
}