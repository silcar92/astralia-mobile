import '../../core/network/api_client.dart';
import '../models/auth_tokens.dart';
import '../models/profile.dart';

/// Acceso al API de cuentas (mismos endpoints que la web).
class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<AuthTokens> login(String email, String password) async {
    // el backend usa el correo como nombre de usuario
    final json = await _api.post(
      '/api/v1/accounts/token/',
      data: {'username': email, 'password': password},
      auth: false,
    );
    return AuthTokens.fromJson(json as Map<String, dynamic>);
  }

  Future<AuthTokens> register({
    required String name,
    required String email,
    required String password,
    required String language,
  }) async {
    final json = await _api.post(
      '/api/v1/accounts/register/',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'language': language,
      },
      auth: false,
    );
    return AuthTokens.fromJson(json as Map<String, dynamic>);
  }

  /// Responde igual exista o no la cuenta (no revela quién está registrado).
  Future<void> forgotPassword(String email) => _api.post(
    '/api/v1/accounts/password/forgot/',
    data: {'email': email},
    auth: false,
  );

  /// Lanza [ApiException] con status 404 si la cuenta aún no tiene perfil (falta el onboarding).
  Future<Profile> fetchMyProfile() async => Profile.fromJson(
    await _api.get('/api/v1/accounts/profile/me/') as Map<String, dynamic>,
  );

  Future<void> updateLanguage(String language) =>
      _api.patch('/api/v1/accounts/profile/me/', data: {'language': language});
}
