import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RestoreAuthSessionUseCase {
  const RestoreAuthSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthSession?>> call() {
    return _repository.restoreSession();
  }
}
