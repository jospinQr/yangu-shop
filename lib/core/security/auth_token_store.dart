import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return SecureAuthTokenStore(const FlutterSecureStorage());
});

abstract interface class AuthTokenStore {
  Future<String?> readAccessToken();

  Future<void> saveAccessToken(String token);

  Future<void> clearAccessToken();
}

class SecureAuthTokenStore implements AuthTokenStore {
  SecureAuthTokenStore(this._storage);

  static const _accessTokenKey = 'auth.access_token';

  final FlutterSecureStorage _storage;
  String? _cachedAccessToken;

  @override
  Future<String?> readAccessToken() async {
    if (_cachedAccessToken != null) {
      return _cachedAccessToken;
    }

    final token = await _storage.read(key: _accessTokenKey);
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) {
      return null;
    }

    _cachedAccessToken = normalizedToken;
    return normalizedToken;
  }

  @override
  Future<void> saveAccessToken(String token) {
    final normalizedToken = token.trim();
    _cachedAccessToken = normalizedToken;
    return _storage.write(key: _accessTokenKey, value: normalizedToken);
  }

  @override
  Future<void> clearAccessToken() {
    _cachedAccessToken = null;
    return _storage.delete(key: _accessTokenKey);
  }
}
