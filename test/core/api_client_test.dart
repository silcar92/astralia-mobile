import 'package:astralia_mobile/app/core/network/api_client.dart';
import 'package:astralia_mobile/app/core/network/api_exception.dart';
import 'package:astralia_mobile/app/core/storage/token_storage.dart';
import 'package:astralia_mobile/app/data/models/auth_tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_adapter.dart';

const _refreshPath = '/api/v1/accounts/token/refresh/';

void main() {
  late MemoryTokenStorage tokens;
  late int expired;

  ApiClient clientFor(FakeAdapter adapter) {
    final dio = Dio()..httpClientAdapter = adapter;
    return ApiClient(
      baseUrl: 'http://api.test',
      tokens: tokens,
      languageCode: () => 'en',
      onSessionExpired: () async => expired++,
      dio: dio,
    );
  }

  setUp(() {
    tokens = MemoryTokenStorage(const AuthTokens(access: 'old', refresh: 'r1'));
    expired = 0;
  });

  test('adjunta el token y el idioma en cada petición', () async {
    final adapter = FakeAdapter({
      '/me': (_, _) => FakeAdapter.json(200, {'ok': true}),
    });
    await clientFor(adapter).get('/me');

    final headers = adapter.requests.single.headers;
    expect(headers['Authorization'], 'Bearer old');
    expect(headers['Accept-Language'], 'en');
  });

  test(
    'las rutas públicas no llevan token ni intentan renovar la sesión',
    () async {
      final adapter = FakeAdapter({
        '/login': (_, _) => FakeAdapter.json(401, {'detail': 'no'}),
      });
      await expectLater(
        clientFor(adapter).post('/login', data: {}, auth: false),
        throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
      );
      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
      expect(adapter.callsTo(_refreshPath), 0);
    },
  );

  test('un 401 renueva el token una vez y repite la petición', () async {
    final adapter = FakeAdapter({
      '/me': (options, _) => options.headers['Authorization'] == 'Bearer new'
          ? FakeAdapter.json(200, {'name': 'Ana'})
          : FakeAdapter.json(401, {'detail': 'vencido'}),
      _refreshPath: (_, _) => FakeAdapter.json(200, {'access': 'new'}),
    });

    final result = await clientFor(adapter).get('/me');

    expect(result, {'name': 'Ana'});
    expect(adapter.callsTo(_refreshPath), 1);
    expect((await tokens.read())!.access, 'new');
    expect((await tokens.read())!.refresh, 'r1'); // el refresh se conserva
  });

  test(
    'varias peticiones que fallan a la vez comparten UNA sola renovación',
    () async {
      final adapter = FakeAdapter({
        '/a': (o, _) => o.headers['Authorization'] == 'Bearer new'
            ? FakeAdapter.json(200, {'r': 'a'})
            : FakeAdapter.json(401, {}),
        '/b': (o, _) => o.headers['Authorization'] == 'Bearer new'
            ? FakeAdapter.json(200, {'r': 'b'})
            : FakeAdapter.json(401, {}),
        '/c': (o, _) => o.headers['Authorization'] == 'Bearer new'
            ? FakeAdapter.json(200, {'r': 'c'})
            : FakeAdapter.json(401, {}),
        _refreshPath: (_, _) => FakeAdapter.json(200, {'access': 'new'}),
      });
      final client = clientFor(adapter);

      final results = await Future.wait([
        client.get('/a'),
        client.get('/b'),
        client.get('/c'),
      ]);

      expect(results.map((r) => (r as Map)['r']), ['a', 'b', 'c']);
      expect(adapter.callsTo(_refreshPath), 1);
    },
  );

  test(
    'si no se puede renovar, se borra la sesión, se avisa y se lanza el error',
    () async {
      final adapter = FakeAdapter({
        '/me': (_, _) => FakeAdapter.json(401, {'detail': 'vencido'}),
        _refreshPath: (_, _) =>
            FakeAdapter.json(401, {'detail': 'refresh vencido'}),
      });

      await expectLater(
        clientFor(adapter).get('/me'),
        throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
      );
      expect(await tokens.read(), isNull);
      expect(expired, 1);
    },
  );

  test('una petición ya repetida no entra en bucle de renovaciones', () async {
    final adapter = FakeAdapter({
      '/me': (_, _) => FakeAdapter.json(401, {}),
      _refreshPath: (_, _) => FakeAdapter.json(200, {'access': 'new'}),
    });

    await expectLater(
      clientFor(adapter).get('/me'),
      throwsA(isA<ApiException>()),
    );
    expect(adapter.callsTo('/me'), 2); // la original y una repetición
    expect(adapter.callsTo(_refreshPath), 1);
  });

  test('sin conexión sale como ApiException con status 0', () async {
    final dio = Dio()
      ..httpClientAdapter = FakeAdapter({
        '/me': (options, _) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'sin red',
        ),
      });
    final client = ApiClient(
      baseUrl: 'http://api.test',
      tokens: tokens,
      dio: dio,
    );

    await expectLater(
      client.get('/me'),
      throwsA(
        isA<ApiException>().having((e) => e.isNetwork, 'isNetwork', true),
      ),
    );
  });

  test('lee el código estable y los códigos de campo del error', () async {
    final adapter = FakeAdapter({
      '/register': (_, _) => FakeAdapter.json(400, {
        'detail': 'texto en español',
        'code': 'validation_error',
        'codes': {
          'email': ['email_taken'],
          'password': ['password_too_short', 'password_too_common'],
        },
      }),
    });

    try {
      await clientFor(adapter).post('/register', data: {}, auth: false);
      fail('debía lanzar');
    } on ApiException catch (e) {
      expect(e.status, 400);
      expect(e.code, 'validation_error');
      expect(e.fieldCodes, [
        'email_taken',
        'password_too_short',
        'password_too_common',
      ]);
    }
  });
}
