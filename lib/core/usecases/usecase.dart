import '../errors/failures.dart';

/// A simple functional type representing an operation that can fail.
///
/// This follows the Clean Architecture pattern where use cases return a `Either`
/// style result, represented here by `Result`.
class Result<T> {
  final T? value;
  final Failure? failure;

  const Result.success(this.value) : failure = null;
  const Result.failure(this.failure) : value = null;

  bool get isSuccess => value != null;
  bool get isFailure => failure != null;
}

/// Base class for use cases.
///
/// Use cases should return a [Result] with either a value or a [Failure].
abstract class UseCase<ReturnType, Params> {
  Future<Result<ReturnType>> call(Params params);
}

/// Use case parameters that don't require any values.
class NoParams {
  const NoParams();
}
