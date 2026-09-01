import 'package:bbo_shop_app/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:bbo_shop_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_dependency_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends Notifier<AuthState> {
  late final RequestOtpUseCase _requestOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;

  @override
  AuthState build() {
    _requestOtpUseCase = ref.watch(requestOtpUseCaseProvider);
    _verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
    return const AuthState.unauthenticated();
  }

  Future<bool> requestOtp(String phoneNumber) async {
    state = state.copyWith(
      isRequestingOtp: true,
      clearRequestOtpError: true,
      clearVerifyOtpError: true,
    );

    final result = await _requestOtpUseCase(phoneNumber);

    return result.match(
      (failure) {
        state = state.copyWith(
          isRequestingOtp: false,
          requestOtpError: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isRequestingOtp: false);
        return true;
      },
    );
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    state = state.copyWith(isVerifyingOtp: true, clearVerifyOtpError: true);

    final result = await _verifyOtpUseCase(
      phoneNumber: phoneNumber,
      code: code,
    );

    return result.match(
      (failure) {
        state = state.copyWith(
          isVerifyingOtp: false,
          verifyOtpError: failure.message,
        );
        return false;
      },
      (session) {
        state = state.copyWith(isVerifyingOtp: false, session: session);
        return true;
      },
    );
  }

  void clearVerifyError() {
    state = state.copyWith(clearVerifyOtpError: true);
  }
}
