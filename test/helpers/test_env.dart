import 'package:astralia_mobile/app/common/theme/astralia_theme.dart';
import 'package:astralia_mobile/app/core/i18n/locale_service.dart';
import 'package:astralia_mobile/app/core/storage/token_storage.dart';
import 'package:astralia_mobile/app/data/repositories/auth_repository.dart';
import 'package:astralia_mobile/app/services/session_service.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Prepara el mismo grafo de dependencias que la app, pero con un repositorio falso y el almacén en memoria.
class TestEnv {
  TestEnv._(this.auth, this.tokens, this.locale, this.session);

  final MockAuthRepository auth;
  final MemoryTokenStorage tokens;
  final LocaleService locale;
  final SessionService session;

  static Future<TestEnv> create({String savedLocale = 'es'}) async {
    Get.reset();
    AstraliaType.useGoogleFonts = false; // las pruebas no descargan fuentes
    SharedPreferences.setMockInitialValues({'astralia_locale': savedLocale});

    final auth = MockAuthRepository();
    final tokens = MemoryTokenStorage();
    final locale = Get.put(
      LocaleService(await SharedPreferences.getInstance()),
      permanent: true,
    );
    final session = Get.put(
      SessionService(auth: auth, tokens: tokens, locale: locale),
      permanent: true,
    );
    Get.put<AuthRepository>(auth, permanent: true);
    return TestEnv._(auth, tokens, locale, session);
  }
}
