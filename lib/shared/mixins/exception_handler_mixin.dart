import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/shared/domain/models/response_model.dart';


mixin ExceptionHandlerMixin on NetworkService {
  Future<Either<AppException, AppResponse>> handleException<T extends Object>(
    Future<Response<dynamic>> Function() handler, {String endpoint = ''}
  ) async {
    try {
      final res = await handler();

      return Right(
        AppResponse(
          statusCode: res.statusCode ?? 200,
          data: res.data,
          statusMessage: res.statusMessage,
        ),
      );
    } catch (e) {
      String message = '';
      String identifier = '';
      int statusCode = 0;
      log(e.runtimeType.toString());

      if (e is SocketException) {
        message = 'Unable to connect to the server.';
        statusCode = 0;
        identifier = 'Socket Exception ${e.message}\n at  $endpoint';
      } else if (e is DioException) {
        message = e.response?.data?['message'] ?? 'Internal Error occurred';
        statusCode = e.response?.statusCode ?? 1;
        identifier = 'DioException ${e.message} \nat  $endpoint';
      } else {
        message = 'Unknown error occurred';
        statusCode = 2;
        identifier = 'Unknown error ${e.toString()}\n at $endpoint';
      }
      return Left(
        AppException(
          message: message,
          statusCode: statusCode,
          identifier: identifier,
        ),
      );
    }
  }
}
