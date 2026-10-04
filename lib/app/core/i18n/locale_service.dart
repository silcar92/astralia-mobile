import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Idioma de la interfaz. Para agregar uno: sumarlo a [supported], crear lib/l10n/app_xx.arb (xx = código del idioma) con las mismas
/// claves que app_es.arb y su nombre en [labels]. (El backend también debe soportarlo: SUPPORTED_LANGUAGES.)
class LocaleService extends GetxService {
  LocaleService(this._prefs);

  static const supported = [Locale('es'), Locale('en')];
  static const labels = {'es': 'Español', 'en': 'English'};
  static const _key = 'astralia_locale';
  static const fallback = Locale('es');

  final SharedPreferences _prefs;
  late final Rx<Locale> locale = _initial().obs;

  Locale _initial() {
    final saved = _prefs.getString(_key);
    return _match(saved) ??
        _match(
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
        ) ??
        fallback;
  }

  Locale? _match(String? code) {
    for (final candidate in supported) {
      if (candidate.languageCode == code) return candidate;
    }
    return null;
  }

  String get code => locale.value.languageCode;

  /// Cambia el idioma y lo recuerda en el teléfono. La app lo sigue sola: AstraliaApp observa [locale].
  Future<void> setLocale(Locale next) async {
    if (_match(next.languageCode) == null) return;
    locale.value = next;
    await _prefs.setString(_key, next.languageCode);
  }

  /// El idioma guardado en la cuenta manda sobre el del teléfono (igual que en la web).
  Future<void> adoptAccountLanguage(String code) async {
    final match = _match(code);
    if (match != null && match != locale.value) await setLocale(match);
  }
}
