import 'package:flutter/material.dart' show Locale;
import 'package:get/get.dart';

import '../core/i18n/locale_service.dart';
import '../core/network/api_exception.dart';
import '../core/storage/token_storage.dart';
import '../data/models/profile.dart';
import '../data/repositories/auth_repository.dart';

enum SessionStatus { loading, guest, needsOnboarding, authenticated }

/// Estado de la sesión de toda la app. Es el equivalente del AuthContext de la web: sabe si hay alguien dentro, si le
/// falta el onboarding, y es quien entra, registra y cierra sesión.
class SessionService extends GetxService {
  SessionService({
    required AuthRepository auth,
    required TokenStorage tokens,
    required LocaleService locale,
  }) : _auth = auth,
       _tokens = tokens,
       _locale = locale;

  final AuthRepository _auth;
  final TokenStorage _tokens;
  final LocaleService _locale;

  final status = SessionStatus.loading.obs;
  final profile = Rxn<Profile>();

  /// Al abrir la app: con sesión guardada carga el perfil; sin ella, invitado. Si no hay red lanza [ApiException]
  /// (con la sesión intacta) para que la pantalla de inicio ofrezca reintentar.
  Future<SessionStatus> bootstrap() async {
    if (await _tokens.read() == null) return _set(SessionStatus.guest);
    return loadProfile();
  }

  Future<SessionStatus> loadProfile() async {
    try {
      final me = await _auth.fetchMyProfile();
      profile.value = me;
      await _locale.adoptAccountLanguage(me.language);
      return _set(SessionStatus.authenticated);
    } on ApiException catch (error) {
      // 404: la cuenta existe pero aún no tiene perfil (falta el onboarding)
      if (error.status == 404) {
        profile.value = null;
        return _set(SessionStatus.needsOnboarding);
      }
      // sesión inválida y sin forma de renovarla (el cliente ya borró los tokens)
      if (error.status == 401) return expire();
      rethrow; // sin red / servidor caído: no se pierde la sesión
    }
  }

  Future<SessionStatus> login(String email, String password) async {
    await _tokens.write(await _auth.login(email, password));
    return loadProfile();
  }

  Future<SessionStatus> register(
    String name,
    String email,
    String password,
  ) async {
    await _tokens.write(
      await _auth.register(
        name: name,
        email: email,
        password: password,
        language: _locale.code,
      ),
    );
    return loadProfile();
  }

  /// Cambio de idioma desde ajustes: se aplica ya y, con sesión iniciada, también se guarda en la cuenta.
  Future<void> changeLanguage(String code) async {
    await _locale.setLocale(Locale(code));
    if (status.value == SessionStatus.authenticated) {
      await _auth
          .updateLanguage(code)
          .catchError((_) {}); // si falla, el idioma local igual quedó cambiado
    }
  }

  Future<void> logout() async {
    await _tokens.clear();
    expireLocally();
  }

  /// Lo llama el cliente HTTP cuando la sesión venció y no se pudo renovar.
  Future<SessionStatus> expire() async {
    await _tokens.clear();
    return expireLocally();
  }

  SessionStatus expireLocally() {
    profile.value = null;
    return _set(SessionStatus.guest);
  }

  SessionStatus _set(SessionStatus next) {
    status.value = next;
    return next;
  }
}
