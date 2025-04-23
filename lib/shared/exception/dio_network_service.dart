import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      errorMessage = "The connection has timed out. Please try again.";
    } else if (err.type == DioExceptionType.badResponse) {
      errorMessage = "An error occurred: ${err.response?.statusCode}";
    } else {
      errorMessage = "An unexpected error occurred: ${err.message}";
    }
    
    if (kDebugMode) {
      print(errorMessage);
    }

    super.onError(err, handler);
  }
}
