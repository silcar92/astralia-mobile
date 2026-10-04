import 'dart:ui' show Locale;
import 'package:astralia_mobile/app/core/network/api_exception.dart';
import 'package:astralia_mobile/app/data/models/auth_tokens.dart';
import 'package:astralia_mobile/app/data/models/profile.dart';
import 'package:astralia_mobile/app/services/session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_env.dart';

const _tokens = AuthTokens(access: 'a', refresh: 'r');
const _profile = Profile(
  id: 1,
  name: 'Ana',
  emailVerified: true,
  language: 'en',
);

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());

  test('sin sesión guardada arranca como invitado', () async {
    expect(await env.session.bootstrap(), SessionStatus.guest);
    verifyNever(() => env.auth.fetchMyProfile());
  });

  test(
    'con sesión guardada carga el perfil y adopta el idioma de la cuenta',
    () async {
      await env.tokens.write(_tokens);
      when(() => env.auth.fetchMyProfile()).thenAnswer((_) async => _profile);

      expect(await env.session.bootstrap(), SessionStatus.authenticated);
      expect(env.session.profile.value?.name, 'Ana');
      expect(env.locale.code, 'en');
    },
  );

  test('un 404 del perfil significa que falta el onboarding', () async {
    await env.tokens.write(_tokens);
    when(() => env.auth.fetchMyProfile()).thenThrow(ApiException(status: 404));

    expect(await env.session.bootstrap(), SessionStatus.needsOnboarding);
    expect(env.session.profile.value, isNull);
  });

  test('un 401 sin remedio cierra la sesión y borra los tokens', () async {
    await env.tokens.write(_tokens);
    when(() => env.auth.fetchMyProfile()).thenThrow(ApiException(status: 401));

    expect(await env.session.bootstrap(), SessionStatus.guest);
    expect(await env.tokens.read(), isNull);
  });

  test(
    'sin red NO se pierde la sesión: el error sube para ofrecer reintentar',
    () async {
      await env.tokens.write(_tokens);
      when(() => env.auth.fetchMyProfile()).thenThrow(ApiException(status: 0));

      await expectLater(env.session.bootstrap(), throwsA(isA<ApiException>()));
      expect(await env.tokens.read(), isNotNull);
    },
  );

  test('entrar guarda los tokens y deja la sesión iniciada', () async {
    when(
      () => env.auth.login('a@b.co', 'secreta123'),
    ).thenAnswer((_) async => _tokens);
    when(() => env.auth.fetchMyProfile()).thenAnswer((_) async => _profile);

    expect(
      await env.session.login('a@b.co', 'secreta123'),
      SessionStatus.authenticated,
    );
    expect((await env.tokens.read())!.refresh, 'r');
  });

  test('si entrar falla no queda nada guardado', () async {
    when(
      () => env.auth.login(any(), any()),
    ).thenThrow(ApiException(status: 401));

    await expectLater(
      env.session.login('a@b.co', 'mala'),
      throwsA(isA<ApiException>()),
    );
    expect(await env.tokens.read(), isNull);
  });

  test('registrar manda el idioma actual de la app', () async {
    await env.locale.setLocale(const Locale('en'));
    when(
      () => env.auth.register(
        name: 'Ana',
        email: 'a@b.co',
        password: 'secreta123',
        language: 'en',
      ),
    ).thenAnswer((_) async => _tokens);
    when(() => env.auth.fetchMyProfile()).thenThrow(ApiException(status: 404));

    expect(
      await env.session.register('Ana', 'a@b.co', 'secreta123'),
      SessionStatus.needsOnboarding,
    );
  });

  test('cerrar sesión borra tokens y perfil', () async {
    await env.tokens.write(_tokens);
    when(() => env.auth.fetchMyProfile()).thenAnswer((_) async => _profile);
    await env.session.bootstrap();

    await env.session.logout();

    expect(env.session.status.value, SessionStatus.guest);
    expect(env.session.profile.value, isNull);
    expect(await env.tokens.read(), isNull);
  });

  test('cambiar el idioma con sesión también lo guarda en la cuenta', () async {
    await env.tokens.write(_tokens);
    when(() => env.auth.fetchMyProfile()).thenAnswer(
      (_) async => const Profile(
        id: 1,
        name: 'Ana',
        emailVerified: true,
        language: 'es',
      ),
    );
    when(() => env.auth.updateLanguage(any())).thenAnswer((_) async {});
    await env.session.bootstrap();

    await env.session.changeLanguage('en');

    expect(env.locale.code, 'en');
    verify(() => env.auth.updateLanguage('en')).called(1);
  });

  test('sin sesión el idioma solo cambia en el teléfono', () async {
    await env.session.changeLanguage('en');
    expect(env.locale.code, 'en');
    verifyNever(() => env.auth.updateLanguage(any()));
  });
}
