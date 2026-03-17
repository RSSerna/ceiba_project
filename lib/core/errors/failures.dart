import 'package:equatable/equatable.dart';

/// Represents a failure that can occur in the domain or data layers.
///
/// This is intentionally simple to keep the sample app focused. Add specific
/// failures as needed (e.g., [InsufficientBalanceFailure], [ServerFailure]).
abstract class Failure extends Equatable {
  const Failure([List<Object?> properties = const <Object?>[]]);

  @override
  List<Object?> get props => [];
}

class InsufficientBalanceFailure extends Failure {}

class InvalidSubscriptionFailure extends Failure {
  final String message;

  const InvalidSubscriptionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {}
