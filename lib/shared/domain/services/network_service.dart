import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/shared/domain/models/response_model.dart';

abstract class NetworkService {
  String get baseUrl;
  
  Map<String, dynamic> get headers;

  void updateHeader(Map<String, dynamic> data);

  void updateBaseUrl(String newBaseUrl);

  Future<Either<AppException, AppResponse>> get(String endpoint, { Map<String, dynamic>? queryParameters });

  Future<Either<AppException, AppResponse>> post(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, AppResponse>> put(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, AppResponse>> patch(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, AppResponse>> delete(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, AppResponse>> uploadFiles(String endpoint, { Map<String, dynamic>? data, required Map<String, String> files});

  Future<Either<AppException, AppResponse>> updateFiles(String endpoint, { Map<String, dynamic>? data, required Map<String, String> files});
}