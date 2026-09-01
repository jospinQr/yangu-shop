import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/core/network/failure_mapper.dart';
import 'package:bbo_shop_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bbo_shop_app/features/auth/data/mappers/auth_session_mapper.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.sendOtp(phoneNumber);
      return right(unit);
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on Object catch (error) {
      return left(
        Failure(
          type: FailureType.unexpected,
          message: 'Impossible d’envoyer le code pour le moment.',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final sessionDto = await _remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      return right(sessionDto.toDomain(phoneNumber));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException catch (error) {
      return left(
        Failure(
          type: FailureType.unexpected,
          message: 'La réponse de connexion est invalide.',
          cause: error,
        ),
      );
    } on Object catch (error) {
      return left(
        Failure(
          type: FailureType.unexpected,
          message: 'Impossible de confirmer le code pour le moment.',
          cause: error,
        ),
      );
    }
  }
}
