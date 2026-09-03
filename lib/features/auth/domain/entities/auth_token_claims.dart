import 'dart:convert';

class AuthTokenClaims {
  const AuthTokenClaims({required this.values, this.decodeError});

  factory AuthTokenClaims.decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        return const AuthTokenClaims(
          values: {},
          decodeError: 'Le token ne suit pas le format JWT attendu.',
        );
      }

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final decodedPayload = jsonDecode(payload);
      if (decodedPayload is! Map<String, dynamic>) {
        return const AuthTokenClaims(
          values: {},
          decodeError: 'Le contenu du token est invalide.',
        );
      }

      return AuthTokenClaims(
        values: Map<String, Object?>.unmodifiable(decodedPayload),
      );
    } on Object {
      return const AuthTokenClaims(
        values: {},
        decodeError: 'Impossible de décoder les informations du token.',
      );
    }
  }

  final Map<String, Object?> values;
  final String? decodeError;

  bool get isDecoded => decodeError == null;

  String? get subject => _stringValue('sub');

  String? get issuer => _stringValue('iss');

  String? get phoneNumber {
    return _firstStringValue([
      'phone_number',
      'phoneNumber',
      'phone',
      'mobile',
      'username',
    ]);
  }

  DateTime? get expiresAt => _dateTimeFromEpochClaim('exp');

  DateTime? get issuedAt => _dateTimeFromEpochClaim('iat');

  DateTime? get notBefore => _dateTimeFromEpochClaim('nbf');

  bool get isExpired {
    final expiration = expiresAt;
    if (expiration == null) {
      return false;
    }
    return !DateTime.now().toUtc().isBefore(expiration);
  }

  List<String> get roles {
    final rawRoles = values['roles'] ?? values['authorities'];
    if (rawRoles is List) {
      return rawRoles.whereType<String>().toList(growable: false);
    }

    final scope = _stringValue('scope') ?? _stringValue('scp');
    if (scope == null || scope.trim().isEmpty) {
      return const [];
    }

    return scope
        .split(RegExp(r'\s+'))
        .where((role) => role.trim().isNotEmpty)
        .toList(growable: false);
  }

  String? _firstStringValue(List<String> keys) {
    for (final key in keys) {
      final value = _stringValue(key);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  String? _stringValue(String key) {
    final value = values[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  DateTime? _dateTimeFromEpochClaim(String key) {
    final value = values[key];
    final seconds = switch (value) {
      int() => value,
      num() => value.toInt(),
      String() => int.tryParse(value),
      _ => null,
    };

    if (seconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }
}
