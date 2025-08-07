String domainEntityTemplate(String className) => '''
import 'package:equatable/equatable.dart';

class $className extends Equatable {
  final String id;
  // TODO: Add other properties for the entity.

  const $className({required this.id});

  @override
  List<Object?> get props => [id];
}
''';

String domainRepoTemplate(String className) => '''
import '../entities/${className.toLowerCase()}.dart';

/// The contract for the data layer.
abstract class ${className}Repository {
  /// Fetches a [$className] object.
  Future<$className> get${className}(String id);
}
''';

String useCaseTemplate(String className, String featureName) => '''
import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

/// A single business logic unit.
class Get$className {
  final ${className}Repository repository;

  Get$className(this.repository);

  /// Executes the use case.
  Future<$className> call(String id) async {
    return await repository.get$className(id);
  }
}
''';