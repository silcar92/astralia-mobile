import 'package:astralia_mobile/app/core/network/api_exception.dart';
import 'package:astralia_mobile/app/core/i18n/locale_service.dart';
import 'package:astralia_mobile/app/data/models/auth_tokens.dart';
import 'package:astralia_mobile/app/data/models/profile.dart';
import 'package:astralia_mobile/app/modules/auth/bindings/auth_bindings.dart';
import 'package:astralia_mobile/app/modules/auth/views/forgot_password_view.dart';
import 'package:astralia_mobile/app/modules/auth/views/login_view.dart';
import 'package:astralia_mobile/app/modules/auth/views/register_view.dart';
import 'package:astralia_mobile/app/routes/app_routes.dart';
import 'package:astralia_mobile/app/services/session_service.dart';
import 'package:astralia_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_env.dart';

const _tokens = AuthTokens(access: 'a', refresh: 'r');
const _profile = Profile(
  id: 1,
  name: 'Ana',
  emailVerified: true,
  language: 'es',
);

Future<void> pumpApp(
  WidgetTester tester,
  String initialRoute, {
  String locale = 'es',
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    GetMaterialApp(
      locale: Locale(locale),
      supportedLocales: LocaleService.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: LoginView.new,
          binding: LoginBinding(),
        ),
        GetPage(
          name: AppRoutes.register,
          page: RegisterView.new,
          binding: RegisterBinding(),
        ),
        GetPage(
          name: AppRoutes.forgotPassword,
          page: ForgotPasswordView.new,
          binding: ForgotPasswordBinding(),
        ),
        GetPage(
          name: AppRoutes.home,
          page: () => const Scaffold(body: Text('HOME')),
        ),
        GetPage(
          name: AppRoutes.onboarding,
          page: () => const Scaffold(body: Text('ONBOARDING')),
        ),
      ],
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(Get.reset);

  group('Entrar', () {
    testWidgets('con los campos vacíos avisa y no llama al servidor', (
      tester,
    ) async {
      await pumpApp(tester, AppRoutes.login);

      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo es obligatorio.'), findsNWidgets(2));
      verifyNever(() => env.auth.login(any(), any()));
    });

    testWidgets('rechaza un correo mal escrito', (tester) async {
      await pumpApp(tester, AppRoutes.login);

      await tester.enterText(
        find.byType(TextFormField).first,
        'no-es-un-correo',
      );
      await tester.enterText(find.byType(TextFormField).last, 'x');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('Escribe un correo válido.'), findsOneWidget);
    });

    testWidgets('entra y va a Home cuando la cuenta ya tiene perfil', (
      tester,
    ) async {
      when(
        () => env.auth.login('ana@mail.co', 'secreta123'),
      ).thenAnswer((_) async => _tokens);
      when(() => env.auth.fetchMyProfile()).thenAnswer((_) async => _profile);
      await pumpApp(tester, AppRoutes.login);

      await tester.enterText(find.byType(TextFormField).first, ' ana@mail.co ');
      await tester.enterText(find.byType(TextFormField).last, 'secreta123');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      expect(env.session.status.value, SessionStatus.authenticated);
    });

    testWidgets('si falta el onboarding, va a esa pantalla', (tester) async {
      when(() => env.auth.login(any(), any())).thenAnswer((_) async => _tokens);
      when(
        () => env.auth.fetchMyProfile(),
      ).thenThrow(ApiException(status: 404));
      await pumpApp(tester, AppRoutes.login);

      await tester.enterText(find.byType(TextFormField).first, 'ana@mail.co');
      await tester.enterText(find.byType(TextFormField).last, 'secreta123');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('ONBOARDING'), findsOneWidget);
    });

    testWidgets(
      'credenciales incorrectas: mensaje claro y se puede reintentar',
      (tester) async {
        when(
          () => env.auth.login(any(), any()),
        ).thenThrow(ApiException(status: 401));
        await pumpApp(tester, AppRoutes.login);

        await tester.enterText(find.byType(TextFormField).first, 'ana@mail.co');
        await tester.enterText(find.byType(TextFormField).last, 'mala-clave');
        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();

        expect(find.text('Correo o contraseña incorrectos.'), findsOneWidget);
        expect(
          find.text('Entrar'),
          findsWidgets,
        ); // el botón volvió a estar disponible
      },
    );

    testWidgets('límite de intentos: muestra el aviso traducido', (
      tester,
    ) async {
      when(
        () => env.auth.login(any(), any()),
      ).thenThrow(ApiException(status: 429, code: 'too_many_attempts'));
      await pumpApp(tester, AppRoutes.login);

      await tester.enterText(find.byType(TextFormField).first, 'ana@mail.co');
      await tester.enterText(find.byType(TextFormField).last, 'x');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Demasiados intentos'), findsOneWidget);
    });

    testWidgets('en inglés todo cambia de idioma', (tester) async {
      await pumpApp(tester, AppRoutes.login, locale: 'en');

      expect(find.text('Enter your galaxy'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
    });

    testWidgets('el selector de idioma cambia el idioma de la pantalla', (
      tester,
    ) async {
      await pumpApp(tester, AppRoutes.login);

      await tester.tap(find.text('Español'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      expect(env.locale.code, 'en');
    });
  });

  group('Crear cuenta', () {
    testWidgets('exige contraseña de 8 caracteres antes de enviar', (
      tester,
    ) async {
      await pumpApp(tester, AppRoutes.register);

      await tester.enterText(find.byType(TextFormField).at(0), 'Ana');
      await tester.enterText(find.byType(TextFormField).at(1), 'ana@mail.co');
      await tester.enterText(find.byType(TextFormField).at(2), 'corta');
      await tester.tap(find.text('Crear cuenta').last);
      await tester.pumpAndSettle();

      expect(find.text('Mínimo 8 caracteres.'), findsOneWidget);
      verifyNever(
        () => env.auth.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          language: any(named: 'language'),
        ),
      );
    });

    testWidgets('correo ya registrado: lo explica', (tester) async {
      when(
        () => env.auth.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          language: any(named: 'language'),
        ),
      ).thenThrow(ApiException(status: 400, fieldCodes: ['email_taken']));
      await pumpApp(tester, AppRoutes.register);

      await tester.enterText(find.byType(TextFormField).at(0), 'Ana');
      await tester.enterText(find.byType(TextFormField).at(1), 'ana@mail.co');
      await tester.enterText(find.byType(TextFormField).at(2), 'secreta123');
      await tester.tap(find.text('Crear cuenta').last);
      await tester.pumpAndSettle();

      expect(find.text('Ya existe una cuenta con ese correo.'), findsOneWidget);
    });

    testWidgets('crea la cuenta y sigue al onboarding', (tester) async {
      when(
        () => env.auth.register(
          name: 'Ana',
          email: 'ana@mail.co',
          password: 'secreta123',
          language: 'es',
        ),
      ).thenAnswer((_) async => _tokens);
      when(
        () => env.auth.fetchMyProfile(),
      ).thenThrow(ApiException(status: 404));
      await pumpApp(tester, AppRoutes.register);

      await tester.enterText(find.byType(TextFormField).at(0), 'Ana');
      await tester.enterText(find.byType(TextFormField).at(1), 'ana@mail.co');
      await tester.enterText(find.byType(TextFormField).at(2), 'secreta123');
      await tester.tap(find.text('Crear cuenta').last);
      await tester.pumpAndSettle();

      expect(find.text('ONBOARDING'), findsOneWidget);
    });
  });

  group('Recuperar contraseña', () {
    testWidgets('envía el correo y confirma sin revelar si la cuenta existe', (
      tester,
    ) async {
      when(
        () => env.auth.forgotPassword('ana@mail.co'),
      ).thenAnswer((_) async {});
      await pumpApp(tester, AppRoutes.forgotPassword);

      await tester.enterText(find.byType(TextFormField), 'ana@mail.co');
      await tester.tap(find.text('Enviar enlace'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgot-sent')), findsOneWidget);
      verify(() => env.auth.forgotPassword('ana@mail.co')).called(1);
    });

    testWidgets('con un correo inválido no envía nada', (tester) async {
      await pumpApp(tester, AppRoutes.forgotPassword);

      await tester.enterText(find.byType(TextFormField), 'xx');
      await tester.tap(find.text('Enviar enlace'));
      await tester.pumpAndSettle();

      expect(find.text('Escribe un correo válido.'), findsOneWidget);
      verifyNever(() => env.auth.forgotPassword(any()));
    });
  });
}
