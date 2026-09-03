import 'package:bbo_shop_app/features/auth/domain/entities/auth_token_claims.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.tokenClaims,
    this.phoneNumber,
    this.isStoredLocally = true,
    this.localStorageError,
  });

  factory AuthSession.fromAccessToken(
    String token, {
    String? phoneNumber,
    bool isStoredLocally = true,
    String? localStorageError,
  }) {
    final claims = AuthTokenClaims.decode(token);
    return AuthSession(
      accessToken: token,
      tokenClaims: claims,
      phoneNumber: phoneNumber?.trim().isNotEmpty == true
          ? phoneNumber!.trim()
          : claims.phoneNumber,
      isStoredLocally: isStoredLocally,
      localStorageError: localStorageError,
    );
  }

  final String? phoneNumber;
  final String accessToken;
  final AuthTokenClaims tokenClaims;
  final bool isStoredLocally;
  final String? localStorageError;

  bool get isExpired => tokenClaims.isExpired;

  AuthSession copyWith({
    String? phoneNumber,
    bool? isStoredLocally,
    String? localStorageError,
    bool clearLocalStorageError = false,
  }) {
    return AuthSession(
      accessToken: accessToken,
      tokenClaims: tokenClaims,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isStoredLocally: isStoredLocally ?? this.isStoredLocally,
      localStorageError: clearLocalStorageError
          ? null
          : localStorageError ?? this.localStorageError,
    );
  }
}
