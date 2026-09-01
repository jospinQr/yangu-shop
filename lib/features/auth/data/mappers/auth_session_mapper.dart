import 'package:bbo_shop_app/features/auth/data/dto/auth_session_dto.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';

extension AuthSessionMapper on AuthSessionDto {
  AuthSession toDomain(String phoneNumber) {
    return AuthSession(phoneNumber: phoneNumber, accessToken: token);
  }
}
