import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber);

  Future<Either<Failure, AuthSession>> verifyOtp({
    required String phoneNumber,
    required String code,
  });
}
