import 'dart:async';

import 'package:bbo_shop_app/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/restore_auth_session_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:bbo_shop_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_dependency_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends Notifier<AuthState> {
  late final RequestOtpUseCase _requestOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final RestoreAuthSessionUseCase _restoreAuthSessionUseCase;
  late final SignOutUseCase _signOutUseCase;

  @override
  AuthState build() {
    _requestOtpUseCase = ref.watch(requestOtpUseCaseProvider);
    _verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
    _restoreAuthSessionUseCase = ref.watch(restoreAuthSessionUseCaseProvider);
    _signOutUseCase = ref.watch(signOutUseCaseProvider);
    unawaited(_restoreSession());
    return const AuthState.restoring();
  }

  Future<void> _restoreSession() async {
    final result = await _restoreAuthSessionUseCase();

    result.match(
      (failure) {
        state = state.copyWith(
          isRestoringSession: false,
          clearSession: true,
          restoreSessionError: failure.message,
        );
      },
      (session) {
        state = state.copyWith(
          isRestoringSession: false,
          session: session,
          clearSession: session == null,
          clearRestoreSessionError: true,
        );
      },
    );
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
        state = state.copyWith(
          isVerifyingOtp: false,
          session: session,
          clearRestoreSessionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> signOut() async {
    final result = await _signOutUseCase();

    return result.match(
      (failure) {
        state = state.copyWith(restoreSessionError: failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
    );
  }

  void clearVerifyError() {
    state = state.copyWith(clearVerifyOtpError: true);
  }
}
