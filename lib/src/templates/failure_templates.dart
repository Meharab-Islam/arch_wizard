// lib/src/templates/failure_templates.dart

String failureTemplate() => '''
import 'package:equatable/equatable.dart';

/// Base Failure class for all error types.
abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object> get props => [message];

  @override
  String toString() => '\$runtimeType: \$message';
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) : super(message);
}

class ServerFailure extends Failure {
  final int? code;

  const ServerFailure(this.code, [String message = 'Server error']) : super(message);

  @override
  List<Object> get props => [message, code ?? -1];
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

class GenericFailure extends Failure {
  const GenericFailure(String message) : super(message);
}
''';

String failureMapperTemplate() => '''
import 'failures.dart';

/// Utility to map exceptions or server errors to Failures.
class FailureMapper {
  static Failure mapExceptionToFailure(Exception exception) {
    final message = exception.toString();

    if (exception.toString().contains('SocketException')) {
      return const NetworkFailure();
    }

    return GenericFailure(message);
  }

  static Failure mapServerError(int code, [String? message]) {
    switch (code) {
      case 400:
        return ServerFailure(code, message ?? 'Bad request');
      case 401:
        return ServerFailure(code, message ?? 'Unauthorized');
      case 404:
        return ServerFailure(code, message ?? 'Not found');
      case 500:
        return ServerFailure(code, message ?? 'Internal server error');
      default:
        return ServerFailure(code, message ?? 'Unknown server error');
    }
  }
}
''';
