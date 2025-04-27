import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';

class AppResponse {
  final int statusCode;
  final String? statusMessage;
  final dynamic data;

  AppResponse({required this.statusCode, this.statusMessage, this.data = const {}});

  @override
  String toString() {
    return 'statusCode=$statusCode\nstatusMessage=$statusMessage\n data=$data';
  }
}

extension AppResponseExtension on AppResponse {
  Right<AppException, AppResponse> get toRight => Right(this);
}