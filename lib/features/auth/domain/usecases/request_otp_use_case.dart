import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RequestOtpUseCase {
  const RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call(String phoneNumber) {
    final normalizedPhoneNumber = phoneNumber.trim();
    if (!_isValidInternationalPhoneNumber(normalizedPhoneNumber)) {
      return Future.value(
        left(
          const Failure(
            type: FailureType.validation,
            message: 'Entrez un numéro au format international.',
          ),
        ),
      );
    }

    return _repository.requestOtp(normalizedPhoneNumber);
  }
}

bool _isValidInternationalPhoneNumber(String value) {
  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(value);
}
