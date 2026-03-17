/// Simple exception classes used by local data sources.
///
/// These are converted into domain [Failure] objects in repository implementations.
class InsufficientBalanceException implements Exception {
  final String message;

  InsufficientBalanceException([this.message = 'Saldo insuficiente']);

  @override
  String toString() => 'InsufficientBalanceException: $message';
}

class InvalidSubscriptionException implements Exception {
  final String message;

  InvalidSubscriptionException([this.message = 'Suscripción inválida']);

  @override
  String toString() => 'InvalidSubscriptionException: $message';
}
