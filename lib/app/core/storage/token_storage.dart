import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/auth_tokens.dart';

/// Dónde se guarda la sesión. En el teléfono va al almacén seguro del sistema (Keystore/Keychain), nunca a
/// SharedPreferences ni a archivos planos.
abstract class TokenStorage {
  Future<AuthTokens?> read();
  Future<void> write(AuthTokens tokens);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessKey = 'astralia_access_token';
  static const _refreshKey = 'astralia_refresh_token';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    return access != null && refresh != null
        ? AuthTokens(access: access, refresh: refresh)
        : null;
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.access);
    await _storage.write(key: _refreshKey, value: tokens.refresh);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}

/// Para pruebas.
class MemoryTokenStorage implements TokenStorage {
  MemoryTokenStorage([this._tokens]);

  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> write(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
