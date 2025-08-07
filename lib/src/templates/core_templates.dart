
import 'package:equatable/equatable.dart';

// --- CORE TEMPLATES ---

/// Template for a generic Failure class.
const String failureTemplate = '''
import 'package:equatable/equatable.dart';

/// A base class for all failures in the application.
/// Failures represent expected, planned error scenarios.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure from a server (e.g., API error).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure from a local cache (e.g., database error).
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
''';

/// Template for custom Exception classes.
const String exceptionsTemplate = '''
/// Represents an error occurring during a server request.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Represents an error occurring during a cache operation.
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
''';

/// Template for a generic UseCase class.
const String useCaseCoreTemplate = '''
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'failures.dart';

/// A generic use case with parameters and a return type.
///
/// [Type] is the return type of the use case.
/// [Params] is the type of the parameters required by the use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// A class for use cases that do not require any parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
''';
