/// =============================================================
/// Domain Layer Templates with Global Failure Handling
/// Author: Meharab Islam Nibir
/// =============================================================

String domainEntityTemplate(String className) => '''
import 'package:equatable/equatable.dart';

/// Domain entity representing [$className].
/// Pure data object with no dependencies on Flutter or Data layer.
class $className extends Equatable {
  final String id;
  // Add more fields here as needed.

  const $className({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
''';

String domainRepoTemplate(String className) => '''
import 'package:dartz/dartz.dart';
import 'package:your_app/core/error/failures.dart';
import '../entities/${className.toLowerCase()}.dart';

/// Abstract repository defining [$className] data operations.
/// Data layer implementations will return Either<Failure, Entity>.
abstract class ${className}Repository {
  /// Fetches a [$className] by [id].
  /// Returns Either Failure or [$className] entity.
  Future<Either<Failure, $className>> get$className(String id);

  // Example additional methods:
  // Future<Either<Failure, $className>> create$className($className entity);
  // Future<Either<Failure, void>> update$className($className entity);
  // Future<Either<Failure, void>> delete$className(String id);
}
''';

String useCaseTemplate(String className, String featureName) => '''
import 'package:dartz/dartz.dart';
import 'package:your_app/core/error/failures.dart';
import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

/// Use case: Gets a single [$className] by ID.
/// Encapsulates business logic for fetching an entity.
class Get$className {
  final ${className}Repository repository;

  const Get$className(this.repository);

  /// Executes the use case and returns Either Failure or Entity.
  Future<Either<Failure, $className>> call(String id) async {
    // Optional: Add validation or business logic here before calling repository.
    return await repository.get$className(id);
  }
}
''';
