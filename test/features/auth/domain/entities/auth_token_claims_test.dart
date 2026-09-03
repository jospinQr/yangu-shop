import 'dart:convert';

import 'package:bbo_shop_app/features/auth/domain/entities/auth_token_claims.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('decodes JWT payload claims', () {
    final token = _jwt({
      'sub': 'user-123',
      'phone_number': '+243970000000',
      'iss': 'yangu-shop-api',
      'iat': 1788206400,
      'exp': 4102444800,
      'scope': 'CUSTOMER SELLER',
    });

    final claims = AuthTokenClaims.decode(token);

    expect(claims.isDecoded, isTrue);
    expect(claims.subject, 'user-123');
    expect(claims.phoneNumber, '+243970000000');
    expect(claims.issuer, 'yangu-shop-api');
    expect(claims.roles, ['CUSTOMER', 'SELLER']);
    expect(claims.isExpired, isFalse);
  });

  test('marks token as expired when exp is in the past', () {
    final token = _jwt({'exp': 1});

    final claims = AuthTokenClaims.decode(token);

    expect(claims.isExpired, isTrue);
  });

  test('reports decode errors for non JWT tokens', () {
    final claims = AuthTokenClaims.decode('opaque-token');

    expect(claims.isDecoded, isFalse);
    expect(claims.values, isEmpty);
    expect(claims.decodeError, isNotNull);
  });
}

String _jwt(Map<String, Object?> payload) {
  final header = _base64UrlJson({'alg': 'none', 'typ': 'JWT'});
  final body = _base64UrlJson(payload);
  return '$header.$body.';
}

String _base64UrlJson(Map<String, Object?> value) {
  return base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
}
