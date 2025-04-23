import 'package:i18nizely/shared/exception/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/shared/domain/models/response_model.dart' as r;

abstract class NetworkService {
  String get baseUrl;
  
  Map<String, dynamic> get headers;

  void updateHeader(Map<String, dynamic> data);

  void updateBaseUrl(String newBaseUrl);

  Future<Either<AppException, r.Response>> get(String endpoint, { Map<String, dynamic>? queryParameters });

  Future<Either<AppException, r.Response>> post(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, r.Response>> put(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, r.Response>> patch(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, r.Response>> delete(String endpoint, { Map<String, dynamic>? data });

  Future<Either<AppException, r.Response>> uploadFile(String endpoint, { Map<String, dynamic>? data, required Map<String, String> files});
}