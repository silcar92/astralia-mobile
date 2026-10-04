import 'package:astralia_mobile/app/core/i18n/error_messages.dart';
import 'package:astralia_mobile/app/core/network/api_exception.dart';
import 'package:astralia_mobile/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final es = lookupAppLocalizations(const Locale('es'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('sin red', () {
    expect(errorMessage(es, ApiException(status: 0)), es.errorNetwork);
  });

  test('el código estable del backend manda sobre el estado HTTP', () {
    expect(
      errorMessage(es, ApiException(status: 400, code: 'too_many_attempts')),
      es.errorTooManyAttempts,
    );
    expect(
      errorMessage(es, ApiException(status: 400, code: 'weak_password')),
      es.errorWeakPassword,
    );
  });

  test('códigos de campo: correo repetido y contraseñas débiles', () {
    expect(
      errorMessage(es, ApiException(status: 400, fieldCodes: ['email_taken'])),
      es.errorEmailTaken,
    );
    for (final code in [
      'password_too_short',
      'password_too_common',
      'password_entirely_numeric',
      'password_too_similar',
    ]) {
      expect(
        errorMessage(es, ApiException(status: 400, fieldCodes: [code])),
        es.errorWeakPassword,
        reason: code,
      );
    }
  });

  test(
    'un 401 al entrar es "correo o contraseña incorrectos"; en otro sitio, sesión vencida',
    () {
      expect(
        errorMessage(
          es,
          ApiException(status: 401),
          wrongCredentialsOn401: true,
        ),
        es.errorInvalidCredentials,
      );
      expect(errorMessage(es, ApiException(status: 401)), es.errorUnauthorized);
    },
  );

  test('429, errores del servidor y desconocidos', () {
    expect(
      errorMessage(es, ApiException(status: 429)),
      es.errorTooManyAttempts,
    );
    expect(errorMessage(es, ApiException(status: 503)), es.errorServer);
    expect(errorMessage(es, ApiException(status: 418)), es.errorGeneric);
    expect(errorMessage(es, StateError('x')), es.errorGeneric);
  });

  test(
    'nunca muestra el detail crudo del servidor y habla el idioma pedido',
    () {
      final error = ApiException(
        status: 400,
        body: {'detail': 'Texto interno en español'},
      );
      expect(errorMessage(en, error), en.errorGeneric);
      expect(errorMessage(en, error), isNot(contains('interno')));
      expect(en.errorGeneric, isNot(es.errorGeneric));
    },
  );
}
