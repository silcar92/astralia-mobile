import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef Responder =
    ResponseBody Function(RequestOptions options, int callNumber);

/// Servidor falso: responde según la ruta, y cuenta cuántas veces se llamó a cada una.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.routes);

  final Map<String, Responder> routes;
  final calls = <String, int>{};
  final requests = <RequestOptions>[];

  int callsTo(String path) => calls[path] ?? 0;

  static ResponseBody json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final count = calls.update(options.path, (n) => n + 1, ifAbsent: () => 1);
    final responder = routes[options.path];
    if (responder == null) return json(404, {'detail': 'sin ruta'});
    await Future<void>.delayed(
      const Duration(milliseconds: 5),
    ); // deja que las peticiones concurrentes se crucen
    return responder(options, count);
  }

  @override
  void close({bool force = false}) {}
}
