import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/auth_repository.dart';
import '../services/session_service.dart';
import 'config/app_config.dart';
import 'i18n/locale_service.dart';
import 'network/api_client.dart';
import 'storage/token_storage.dart';

/// Crea y registra los servicios de toda la app. Las pruebas pasan sus propias versiones (almacén en memoria, otro Dio).
Future<void> initDependencies({
  TokenStorage? tokens,
  ApiClient? api,
  SharedPreferences? prefs,
}) async {
  final storage = tokens ?? SecureTokenStorage();
  final locale = Get.put(
    LocaleService(prefs ?? await SharedPreferences.getInstance()),
    permanent: true,
  );

  late final SessionService session;
  final client =
      api ??
      ApiClient(
        baseUrl: AppConfig.apiBaseUrl,
        tokens: storage,
        languageCode: () => locale.code,
        // la sesión venció y no se pudo renovar: de vuelta a entrar
        onSessionExpired: () async {
          session.expireLocally();
          Get.offAllNamed('/login');
        },
      );
  final auth = Get.put(AuthRepository(client), permanent: true);
  session = Get.put(
    SessionService(auth: auth, tokens: storage, locale: locale),
    permanent: true,
  );
}
