import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';

class AuthState {
  const AuthState({
    required this.isRequestingOtp,
    required this.isVerifyingOtp,
    this.session,
    this.requestOtpError,
    this.verifyOtpError,
  });

  const AuthState.unauthenticated()
    : isRequestingOtp = false,
      isVerifyingOtp = false,
      session = null,
      requestOtpError = null,
      verifyOtpError = null;

  final bool isRequestingOtp;
  final bool isVerifyingOtp;
  final AuthSession? session;
  final String? requestOtpError;
  final String? verifyOtpError;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isRequestingOtp,
    bool? isVerifyingOtp,
    AuthSession? session,
    bool clearSession = false,
    String? requestOtpError,
    bool clearRequestOtpError = false,
    String? verifyOtpError,
    bool clearVerifyOtpError = false,
  }) {
    return AuthState(
      isRequestingOtp: isRequestingOtp ?? this.isRequestingOtp,
      isVerifyingOtp: isVerifyingOtp ?? this.isVerifyingOtp,
      session: clearSession ? null : session ?? this.session,
      requestOtpError: clearRequestOtpError
          ? null
          : requestOtpError ?? this.requestOtpError,
      verifyOtpError: clearVerifyOtpError
          ? null
          : verifyOtpError ?? this.verifyOtpError,
    );
  }
}
