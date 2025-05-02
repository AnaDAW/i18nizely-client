import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/shared/domain/models/response_model.dart';

class AppException implements Exception {
  final dynamic data;
  final int? statusCode;
  final String? identifier;

  AppException({
    required this.data,
    required this.statusCode,
    required this.identifier,
  });
  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$data\nidentifier=$identifier';
  }
}

extension HttpExceptionExtension on AppException {
  Left<AppException, AppResponse> get toLeft => Left<AppException, AppResponse>(this);
}