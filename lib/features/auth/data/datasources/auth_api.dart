import 'package:bbo_shop_app/core/network/auth_header_interceptor.dart';
import 'package:bbo_shop_app/features/auth/data/dto/send_otp_request_dto.dart';
import 'package:bbo_shop_app/features/auth/data/dto/verify_otp_request_dto.dart';
import 'package:dio/dio.dart';

class AuthApi {
  const AuthApi(this._dio);

  final Dio _dio;

  Future<dynamic> sendOtp(SendOtpRequestDto request) async {
    final response = await _dio.post<Object>(
      '/auth/send-otp',
      data: request.toJson(),
      options: Options(extra: const {skipAuthExtraKey: true}),
    );
    return response.data;
  }

  Future<dynamic> verifyOtp(VerifyOtpRequestDto request) async {
    final response = await _dio.post<Object>(
      '/auth/verify',
      data: request.toJson(),
      options: Options(extra: const {skipAuthExtraKey: true}),
    );
    return response.data;
  }
}
