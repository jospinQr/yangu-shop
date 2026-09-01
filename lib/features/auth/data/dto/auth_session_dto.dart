class AuthSessionDto {
  const AuthSessionDto({required this.token});

  final String token;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    if (token is! String || token.trim().isEmpty) {
      throw const FormatException(
        'Verify OTP response must contain a non-empty token field.',
      );
    }

    return AuthSessionDto(token: token.trim());
  }
}
