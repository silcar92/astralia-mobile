import 'dart:async';

import 'package:dio/dio.dart';

import '../../data/models/auth_tokens.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Cliente HTTP del API. Se encarga de tres cosas para que el resto de la app no tenga que pensarlas:
/// 1. adjunta el token de acceso e `Accept-Language` en cada petición;
/// 2. si el servidor responde 401, renueva el token UNA sola vez aunque haya varias peticiones fallando a la vez, y
///    repite la petición original;
/// 3. si no se puede renovar, borra la sesión y avisa (`onSessionExpired`).
/// Los errores salen siempre como [ApiException].
class ApiClient {
  ApiClient({
    required String baseUrl,
    required this.tokens,
    this.languageCode,
    this.onSessionExpired,
    Dio? dio,
  }) : dio = dio ?? Dio() {
    this.dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 20)
      // el backend gratuito se duerme y puede tardar en despertar
      ..receiveTimeout = const Duration(seconds: 60)
      ..headers['Content-Type'] = 'application/json';
    this.dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  final Dio dio;
  final TokenStorage tokens;

  /// Idioma actual de la interfaz (se lee en cada petición, así sigue los cambios).
  final String Function()? languageCode;
  final Future<void> Function()? onSessionExpired;

  static const _authKey = 'auth';
  static const _retriedKey = 'retried';

  Future<String?>? _refreshing;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = languageCode?.call();
    if (language != null) options.headers['Accept-Language'] = language;

    if (options.extra[_authKey] != false) {
      final current = await tokens.read();
      if (current != null) {
        options.headers['Authorization'] = 'Bearer ${current.access}';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final canRefresh =
        error.response?.statusCode == 401 &&
        request.extra[_authKey] != false &&
        request.extra[_retriedKey] != true;
    if (!canRefresh) return handler.next(error);

    final newAccess = await (_refreshing ??= _refresh().whenComplete(
      () => _refreshing = null,
    ));
    if (newAccess == null) return handler.next(error);

    try {
      request.extra[_retriedKey] = true;
      request.headers['Authorization'] = 'Bearer $newAccess';
      handler.resolve(await dio.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refresh() async {
    final current = await tokens.read();
    if (current == null) return null;
    try {
      // cliente aparte, sin interceptores: renovar no debe renovarse a sí mismo
      final plain = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      )..httpClientAdapter = dio.httpClientAdapter;
      final response = await plain.post<Map<String, dynamic>>(
        '/api/v1/accounts/token/refresh/',
        data: {'refresh': current.refresh},
      );
      final access = response.data!['access'] as String;
      await tokens.write(AuthTokens(access: access, refresh: current.refresh));
      return access;
    } on DioException {
      await tokens.clear();
      await onSessionExpired?.call();
      return null;
    }
  }

  /// `auth: false` en las rutas públicas (entrar, registrar, recuperar contraseña).
  Future<dynamic> request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    try {
      final response = await dio.request<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method, extra: {_authKey: auth}),
      );
      return response.data;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => request('GET', path, query: query, auth: auth);

  Future<dynamic> post(String path, {Object? data, bool auth = true}) =>
      request('POST', path, data: data, auth: auth);

  Future<dynamic> patch(String path, {Object? data}) =>
      request('PATCH', path, data: data);
}
