import 'dart:io';

import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

abstract class KeyApi {
  Future<Either<AppException, List<TransKey>>> getKeys({required int projectId, int page = 1});

  Future<Either<AppException, TransKey>> createKey({required int projectId, required TransKey newKey});
  
  Future<Either<AppException, TransKey>> updateKey({required int projectId, required TransKey newKey});
  
  Future<Either<AppException, TransKey>> addImage({required int projectId, required int id, required File image});
  
  Future<Either<AppException, void>> deleteKey({required int projectId, required int id});
}