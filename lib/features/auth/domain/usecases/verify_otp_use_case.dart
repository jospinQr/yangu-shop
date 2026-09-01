import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthSession>> call({
    required String phoneNumber,
    required String code,
  }) {
    final normalizedPhoneNumber = phoneNumber.trim();
    final normalizedCode = code.trim();

    if (!_isValidInternationalPhoneNumber(normalizedPhoneNumber)) {
      return Future.value(
        left(
          const Failure(
            type: FailureType.validation,
            message: 'Le numéro de téléphone est invalide.',
          ),
        ),
      );
    }

    if (!RegExp(r'^\d{6}$').hasMatch(normalizedCode)) {
      return Future.value(
        left(
          const Failure(
            type: FailureType.validation,
            message: 'Entrez le code à 6 chiffres.',
          ),
        ),
      );
    }

    return _repository.verifyOtp(
      phoneNumber: normalizedPhoneNumber,
      code: normalizedCode,
    );
  }
}

bool _isValidInternationalPhoneNumber(String value) {
  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(value);
}
