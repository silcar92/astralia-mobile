# Astralia Mobile

App Flutter de Astralia (Android e iOS). Usa el mismo backend que la web (`../astralia-backend`).

## Estado
Base lista: arquitectura, tema de la marca, sesión (entrar, crear cuenta, recuperar contraseña, renovación automática del
token), navegación y español/inglés. Las cinco secciones principales son marcadores ("Próximamente") que se van
reemplazando por su módulo real, y el onboarding también es un marcador.

## Correr la app
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://astralia-backend.onrender.com
```
Sin `--dart-define` apunta a `http://10.0.2.2:8000` (el backend local visto desde el emulador de Android).

## Calidad
```bash
flutter analyze
flutter test
dart format lib test
```
El CI de GitHub Actions corre formato, análisis y pruebas en cada push (informativo).

## Arquitectura (GetX, mismo patrón de módulos que WiiGold Wallet)
```
lib/
  main.dart
  l10n/                    textos (app_es.arb es la plantilla; app_en.arb)
  app/
    app.dart               GetMaterialApp (idioma reactivo)
    core/                  config, red (ApiClient), almacenamiento seguro de tokens, i18n, errores traducidos, DI
    common/                diseño: tema, colores y widgets (GoldButton, GlassCard, AstraliaTextField, StarMark…)
    data/                  models/ y repositories/ (acceso al API)
    services/              SessionService (estado de la sesión de toda la app)
    routes/                rutas y middleware de sesión
    modules/<feature>/     bindings/ controllers/ views/ widgets/
```
Reglas: la interfaz nunca muestra el `detail` del servidor; traduce el `code` con `core/i18n/error_messages.dart`.
Los tokens van al almacén seguro del sistema. Un 401 renueva el token una sola vez aunque fallen varias peticiones a la vez.

## Agregar un idioma
1. Sumarlo a `LocaleService.supported` y `labels`.
2. Crear `lib/l10n/app_<código>.arb` con las mismas claves que `app_es.arb` (la prueba `arb_parity_test` avisa de lo que falte).
3. Sumarlo a `SUPPORTED_LANGUAGES` en el backend.

## Producción (pendiente)
Íconos y nombre de la app, firma de Android, cuentas de desarrollador (Google Play y Apple) y fuentes incluidas en la app
(hoy `google_fonts` las descarga al primer uso).
