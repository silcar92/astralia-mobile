/// Configuración de la app. El API se cambia al compilar:
///   flutter run --dart-define=API_BASE_URL=https://astralia-backend.onrender.com
/// Por defecto apunta al backend local visto desde el emulador de Android (10.0.2.2 es el computador anfitrión).
class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
