enum FailureType {
  noNetwork,
  serverUnreachable,
  authentication,
  validation,
  authorization,
  conflict,
  rateLimited,
  unexpected,
}

class Failure {
  const Failure({required this.type, required this.message, this.cause});

  final FailureType type;
  final String message;
  final Object? cause;
}
