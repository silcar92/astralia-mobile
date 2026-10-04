import 'package:dio/dio.dart';

/// Error del API con la misma forma que usa la web: `{detail, code, codes}`. La interfaz nunca muestra `detail`
/// (viene en español): traduce `code` o los códigos de campo con `errorMessage` (core/i18n/error_messages.dart).
class ApiException implements Exception {
  ApiException({
    required this.status,
    this.code,
    this.fieldCodes = const [],
    this.body,
  });

  /// Código HTTP. 0 significa que no hubo respuesta (sin internet, servidor caído, tiempo agotado).
  final int status;

  /// Código estable del backend, ej. `too_many_attempts`.
  final String? code;

  /// Códigos de error de campos aplanados, ej. `email_taken`, `password_too_short`.
  final List<String> fieldCodes;
  final Object? body;

  bool get isNetwork => status == 0;
  bool get isServerError => status >= 500;

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    if (response == null) return ApiException(status: 0);

    final body = response.data;
    final map = body is Map ? body : const {};
    final code = map['code'];
    return ApiException(
      status: response.statusCode ?? 0,
      code: code is String ? code : null,
      fieldCodes: _flatten(map['codes']),
      body: body,
    );
  }

  static List<String> _flatten(Object? value) {
    if (value is String) return [value];
    if (value is List) return value.expand(_flatten).toList();
    if (value is Map) return value.values.expand(_flatten).toList();
    return const [];
  }

  @override
  String toString() =>
      'ApiException($status, code: $code, fields: $fieldCodes)';
}
