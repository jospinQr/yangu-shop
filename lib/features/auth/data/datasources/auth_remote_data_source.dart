import 'package:bbo_shop_app/features/auth/data/datasources/auth_api.dart';
import 'package:bbo_shop_app/features/auth/data/dto/auth_session_dto.dart';
import 'package:bbo_shop_app/features/auth/data/dto/send_otp_request_dto.dart';
import 'package:bbo_shop_app/features/auth/data/dto/verify_otp_request_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> sendOtp(String phoneNumber);

  Future<AuthSessionDto> verifyOtp({
    required String phoneNumber,
    required String code,
  });
}

class SpringAuthRemoteDataSource implements AuthRemoteDataSource {
  const SpringAuthRemoteDataSource(this._api);

  final AuthApi _api;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await _api.sendOtp(SendOtpRequestDto(phoneNumber: phoneNumber));
  }

  @override
  Future<AuthSessionDto> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _api.verifyOtp(
      VerifyOtpRequestDto(phoneNumber: phoneNumber, code: code),
    );

    if (response is Map<String, dynamic>) {
      return AuthSessionDto.fromJson(response);
    }

    throw const FormatException('Verify OTP response must be a JSON object.');
  }
}
