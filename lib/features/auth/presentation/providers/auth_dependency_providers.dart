import 'package:bbo_shop_app/core/network/dio_provider.dart';
import 'package:bbo_shop_app/core/security/auth_token_store.dart';
import 'package:bbo_shop_app/features/auth/data/datasources/auth_api.dart';
import 'package:bbo_shop_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bbo_shop_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/restore_auth_session_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:bbo_shop_app/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return SpringAuthRemoteDataSource(ref.watch(authApiProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authTokenStoreProvider),
  );
});

final requestOtpUseCaseProvider = Provider<RequestOtpUseCase>((ref) {
  return RequestOtpUseCase(ref.watch(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
});

final restoreAuthSessionUseCaseProvider = Provider<RestoreAuthSessionUseCase>((
  ref,
) {
  return RestoreAuthSessionUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});
