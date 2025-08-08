// core/error/failures.dart
import 'package:equatable/equatable.dart';

/// Base class for all failures.
/// This allows you to have a unified way of returning errors from repositories.
/// Instead of throwing exceptions, return `Left(Failure)`.
abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// General server failure (e.g., API error, Firebase error).
class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message);
}

/// Failure due to no internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([String? message]) : super(message);
}

/// Failure for cache or local storage problems.
class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super(message);
}

/// Failure for validation errors (e.g., invalid email).
class ValidationFailure extends Failure {
  const ValidationFailure([String? message]) : super(message);
}
