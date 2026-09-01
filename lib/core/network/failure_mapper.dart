import 'package:bbo_shop_app/core/errors/failure.dart';
import 'package:dio/dio.dart';

Failure mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError) {
    return Failure(
      type: FailureType.serverUnreachable,
      message: 'Le serveur est injoignable. Réessayez dans un instant.',
      cause: error,
    );
  }

  if (statusCode == 400 || statusCode == 422) {
    return Failure(
      type: FailureType.validation,
      message:
          _extractMessage(error.response?.data) ??
          'Vérifiez les informations saisies.',
      cause: error,
    );
  }

  if (statusCode == 401) {
    return Failure(
      type: FailureType.authentication,
      message: 'Connexion refusée. Vérifiez le code reçu.',
      cause: error,
    );
  }

  if (statusCode == 403) {
    return Failure(
      type: FailureType.authorization,
      message: 'Vous n’avez pas l’autorisation pour cette action.',
      cause: error,
    );
  }

  if (statusCode == 409) {
    return Failure(
      type: FailureType.conflict,
      message: 'Cette action ne peut pas être terminée pour le moment.',
      cause: error,
    );
  }

  if (statusCode == 429) {
    return Failure(
      type: FailureType.rateLimited,
      message: 'Trop de tentatives. Patientez un moment avant de réessayer.',
      cause: error,
    );
  }

  return Failure(
    type: FailureType.unexpected,
    message: 'Une erreur inattendue est survenue.',
    cause: error,
  );
}

String? _extractMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'] ?? data['error'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
  }
  return null;
}
