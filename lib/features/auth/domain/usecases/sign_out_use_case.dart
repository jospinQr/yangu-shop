import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call() {
    return _repository.signOut();
  }
}
