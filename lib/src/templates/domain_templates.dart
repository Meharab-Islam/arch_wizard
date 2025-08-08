/// =============================================================
/// Domain Layer Templates with Global Failure Handling
/// Author: Meharab Islam Nibir
/// Description:
///   Generic domain layer templates supporting Either<Failure, Entity>
///   pattern for functional error handling.
/// =============================================================

/// ------------------------------
/// Domain Entity Template
/// ------------------------------
String domainEntityTemplate(String className) => '''
import 'package:equatable/equatable.dart';

/// Domain entity representing [$className].
/// This is a pure data class with no dependencies on Flutter or Data layers.
class $className extends Equatable {
  final String id;
  // TODO: Add additional fields relevant to $className here.

  const $className({
    required this.id,
    // Initialize additional fields here.
  });

  @override
  List<Object?> get props => [id /*, add additional fields here */];
}
''';

/// ------------------------------
/// Domain Repository Interface Template
/// ------------------------------
String domainRepoTemplate(String className) => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/${className.toLowerCase()}.dart';

/// Abstract repository interface for [$className].
/// Defines the contract for data operations, returning Either<Failure, Entity>.
abstract class ${className}Repository {
  /// Fetch a single [$className] entity by its [id].
  Future<Either<Failure, $className>> get$className(String id);

  // TODO: Add additional CRUD methods as needed, for example:
  // Future<Either<Failure, $className>> create$className($className entity);
  // Future<Either<Failure, void>> update$className($className entity);
  // Future<Either<Failure, void>> delete$className(String id);
}
''';

/// ------------------------------
/// Use Case Template
/// ------------------------------
String useCaseTemplate(String className, String featureName) => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

/// Use case to fetch a [$className] by ID.
/// This class encapsulates business logic and error handling.
class Get$className {
  final ${className}Repository repository;

  const Get$className(this.repository);

  /// Executes the use case with the given [id].
  /// Returns either a Failure or the requested [$className].
  Future<Either<Failure, $className>> call(String id) async {
    // Optional: Add input validation or other business logic here.

    // Delegate to the repository implementation.
    return await repository.get$className(id);
  }
}
''';
