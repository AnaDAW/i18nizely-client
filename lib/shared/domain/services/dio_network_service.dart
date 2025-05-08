
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/shared/domain/models/response_model.dart';
import 'package:i18nizely/shared/mixins/exception_handler_mixin.dart';

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  final Dio dio;

  DioNetworkService(this.dio) {
      dio.options = dioBaseOptions;
      if (kDebugMode) {
        dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      }
  }

  BaseOptions get dioBaseOptions => BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {},
  );

  @override
  String get baseUrl => dio.options.baseUrl;

  @override
  Map<String, dynamic> get headers => dio.options.headers;

  @override
  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
  }

  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    final header = {...headers, ...data};
    dio.options.headers = header;
    return header;
  }

  @override
  Future<Either<AppException, AppResponse>> get(String endpoint, { Map<String, dynamic>? queryParameters }) {
    final res = handleException(
      () => dio.get(
        endpoint,
        queryParameters: queryParameters,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, AppResponse>> post(String endpoint, { Map<String, dynamic>? data }) {
    final res = handleException(
      () => dio.post(
        endpoint,
        data: data,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, AppResponse>> put(String endpoint, { Map<String, dynamic>? data }) {
    final res = handleException(
      () => dio.put(
        endpoint,
        data: data,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, AppResponse>> patch(String endpoint, { Map<String, dynamic>? data }) {
    final res = handleException(
      () => dio.patch(
        endpoint,
        data: data,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, AppResponse>> delete(String endpoint, { Map<String, dynamic>? data }) {
    final res = handleException(
      () => dio.delete(
        endpoint,
        data: data,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, AppResponse>> uploadFile(String endpoint, { Map<String, dynamic>? data, required Map<String, String> files }) async {
    final FormData formData = data != null ? FormData.fromMap(data.map((key, value) => MapEntry(key, value.toString()))) : FormData();
    
    for(MapEntry<String, String> entry in files.entries) {
      final MultipartFile file = await MultipartFile.fromFile(entry.value);
      formData.files.add(MapEntry(entry.key, file));
    }

    final res = handleException(
          () => dio.post(
        endpoint,
        data: formData,
      ),
      endpoint: endpoint,
    );
    return res;
  }
}