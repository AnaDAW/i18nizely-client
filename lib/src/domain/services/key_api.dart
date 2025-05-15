import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

abstract class KeyApi {
  Future<Either<AppException, Map<String,dynamic>>> getKeys({required int projectId, int page = 1, String? name});

  Future<Either<AppException, TransKey>> createKey({required int projectId, required TransKey newKey, required String translation});
  
  Future<Either<AppException, TransKey>> updateKey({required int projectId, required TransKey newKey});
  
  Future<Either<AppException, TransKey>> addImage({required int projectId, required int id, required String imagePath});
  
  Future<Either<AppException, TransKey>> removeImage({required int projectId, required int id});
  
  Future<Either<AppException, void>> deleteKey({required int projectId, required int id});

  Future<Either<AppException, List<TransKey>>> importKeys({required int projectId, required Map<String, String> files});

  Future<Either<AppException, void>> exportKeys({required int projectId, required String filePath, List<String>? fileTypes, List<String>? languages, bool onlyReviewed = false});
}