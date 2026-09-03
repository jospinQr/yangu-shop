import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:bbo_shop_app/core/network/failure_mapper.dart';
import 'package:bbo_shop_app/core/security/auth_token_store.dart';
import 'package:bbo_shop_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bbo_shop_app/features/auth/data/mappers/auth_session_mapper.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:bbo_shop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._tokenStore);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthTokenStore _tokenStore;

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
      final session = sessionDto.toDomain(phoneNumber);
      try {
        await _tokenStore.saveAccessToken(session.accessToken);
        return right(session);
      } on Object {
        return right(
          session.copyWith(
            isStoredLocally: false,
            localStorageError: 'Connexion réussie, mais la session ne peut pas être conservée sur cet appareil.',
          ),
        );
      }
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

  @override
  Future<Either<Failure, AuthSession?>> restoreSession() async {
    try {
      final token = await _tokenStore.readAccessToken();
      if (token == null) {
        return right(null);
      }

      final session = AuthSession.fromAccessToken(token);
      if (session.isExpired) {
        await _tokenStore.clearAccessToken();
        return right(null);
      }

      return right(session);
    } on Object catch (error) {
      return left(
        Failure(
          type: FailureType.unexpected,
          message: 'Impossible de restaurer la session locale.',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _tokenStore.clearAccessToken();
      return right(unit);
    } on Object catch (error) {
      return left(
        Failure(
          type: FailureType.unexpected,
          message: 'Impossible de fermer la session locale.',
          cause: error,
        ),
      );
    }
  }
}
