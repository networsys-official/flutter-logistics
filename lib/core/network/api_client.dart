import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';

import 'package:logistic_by_strom/core/providers/session_provider.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final storageService = ref.watch(storageServiceProvider.notifier);
  final sessionNotifier = ref.watch(sessionProvider.notifier);
  return ApiClient(storageService, sessionNotifier);
}

class ApiClient {
  ApiClient(this._storageService, this._sessionNotifier) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            _sessionNotifier.triggerUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  late final Dio _dio;
  final StorageService _storageService;
  final SessionNotifier _sessionNotifier;

  Future<Response> _request(Future<Response> Function() requestFn) async {
    try {
      return await requestFn();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.get(path, queryParameters: queryParameters, options: options),
  );
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) => _request(
    () => _dio.post(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: options,
      cancelToken: cancelToken,
    ),
  );
}
