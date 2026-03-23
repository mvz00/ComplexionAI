import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  late final Dio _dio;
  final SupabaseClient _supabase;

  ApiClient(this._supabase) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final session = _supabase.auth.currentSession;
          if (session != null) {
            options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: timeout != null
          ? Options(receiveTimeout: timeout, sendTimeout: timeout)
          : null,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Duration? timeout,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      options: timeout != null
          ? Options(receiveTimeout: timeout, sendTimeout: timeout)
          : null,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
