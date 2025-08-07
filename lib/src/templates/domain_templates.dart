String domainEntityTemplate(String className) => '''
import 'package:equatable/equatable.dart';

class $className extends Equatable {
  final String id;
  final String name; // Example of an additional property

  const $className({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
''';


String domainRepoTemplate(String className) => '''
// TODO: Add the 'dartz' package to your pubspec.yaml for Either type.
// TODO: Create a Failure class hierarchy (e.g., core/error/failures.dart).
// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failures.dart';
import '../entities/${className.toLowerCase()}.dart';

/// The contract for the data layer.
abstract class ${className}Repository {
  /// Fetches a [$className] object.
  /// Returns [Either] a [Failure] or the [$className] data.
  Future< /* Either<Failure,*/ $className> get${className}(String id);
}
''';

String useCaseTemplate(String className, String featureName) => '''
// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failures.dart';
import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

/// A single business logic unit.
class Get$className {
  final ${className}Repository repository;

  Get$className(this.repository);

  /// Executes the use case.
  Future< /* Either<Failure,*/ $className> call(String id) async {
    // This is where more complex business logic could go,
    // like combining data from multiple repositories.
    return await repository.get$className(id);
  }
}
''';
