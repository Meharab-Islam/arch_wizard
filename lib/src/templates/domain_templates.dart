String domainEntityTemplate(String className) => '''
import 'package:equatable/equatable.dart';

/// Domain entity representing [$className].
/// This is a plain, immutable class that defines core properties of your feature.
class $className extends Equatable {
  // TODO: Define required properties
  // final String name;
  // final int age;

  const $className({
    // TODO: Add required fields to constructor
    // required this.name,
    // required this.age,
  });

  @override
  List<Object?> get props => [
    // TODO: Add properties to props list
    // name,
    // age,
  ];
}
''';


String domainRepoTemplate(String className) => '''
// TODO: Uncomment and configure if using error handling via dartz
// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failures.dart';

import '../entities/${className.toLowerCase()}.dart';

/// Repository contract for [$className].
/// Handles data access from different sources (API, cache, DB, etc.).
abstract class ${className}Repository {
  /// Fetches [$className] from data source.
  /// 
  /// You can return Either<Failure, $className> for error handling if desired.
  Future</* Either<Failure, */ $className /* > */> get$className(
    /* TODO: Add required parameters, e.g. String id */
  );
}
''';
String useCaseTemplate(String className, String featureName) => '''
// TODO: Uncomment and configure if using error handling via dartz
// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failures.dart';

import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

/// Use case for fetching [$className].
/// Encapsulates business logic for the operation.
class Get$className {
  final ${className}Repository repository;

  Get$className(this.repository);

  /// Executes the use case.
  Future</* Either<Failure, */ $className /* > */> call(
    /* TODO: Add required parameters, e.g. String id */
  ) async {
    // TODO: Add any business rules or preprocessing here
    return await repository.get$className(
      /* TODO: Pass parameters here */
    );
  }
}
''';
