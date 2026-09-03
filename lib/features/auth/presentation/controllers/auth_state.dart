import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';

class AuthState {
  const AuthState({
    required this.isRestoringSession,
    required this.isRequestingOtp,
    required this.isVerifyingOtp,
    this.session,
    this.restoreSessionError,
    this.requestOtpError,
    this.verifyOtpError,
  });

  const AuthState.unauthenticated()
    : isRestoringSession = false,
      isRequestingOtp = false,
      isVerifyingOtp = false,
      session = null,
      restoreSessionError = null,
      requestOtpError = null,
      verifyOtpError = null;

  const AuthState.restoring()
    : isRestoringSession = true,
      isRequestingOtp = false,
      isVerifyingOtp = false,
      session = null,
      restoreSessionError = null,
      requestOtpError = null,
      verifyOtpError = null;

  final bool isRestoringSession;
  final bool isRequestingOtp;
  final bool isVerifyingOtp;
  final AuthSession? session;
  final String? restoreSessionError;
  final String? requestOtpError;
  final String? verifyOtpError;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isRestoringSession,
    bool? isRequestingOtp,
    bool? isVerifyingOtp,
    AuthSession? session,
    bool clearSession = false,
    String? restoreSessionError,
    bool clearRestoreSessionError = false,
    String? requestOtpError,
    bool clearRequestOtpError = false,
    String? verifyOtpError,
    bool clearVerifyOtpError = false,
  }) {
    return AuthState(
      isRestoringSession: isRestoringSession ?? this.isRestoringSession,
      isRequestingOtp: isRequestingOtp ?? this.isRequestingOtp,
      isVerifyingOtp: isVerifyingOtp ?? this.isVerifyingOtp,
      session: clearSession ? null : session ?? this.session,
      restoreSessionError: clearRestoreSessionError
          ? null
          : restoreSessionError ?? this.restoreSessionError,
      requestOtpError: clearRequestOtpError
          ? null
          : requestOtpError ?? this.requestOtpError,
      verifyOtpError: clearVerifyOtpError
          ? null
          : verifyOtpError ?? this.verifyOtpError,
    );
  }
}
