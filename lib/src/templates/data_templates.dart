String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// [${className}Model] extends the domain entity [$className] and
/// is responsible for parsing from and converting to JSON.
class ${className}Model extends $className {
  // TODO: Add model-specific properties here (if any)

  const ${className}Model({
    // TODO: Add required super.fieldName,
    // required super.name,
  });

  /// Creates a [${className}Model] from JSON data.
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      // TODO: Map JSON fields to constructor parameters
      // name: json['name'] as String,
    );
  }

  /// Converts [${className}Model] instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      // TODO: Map model properties to JSON keys
      // 'name': name,
    };
  }
}
''';


String remoteDataSourceTemplate(String className, String featureName) => '''
import '../models/${featureName}_model.dart';

/// Abstract contract for remote data operations related to [$className].
abstract class ${className}RemoteDataSource {
  /// Fetches [$className] from remote source by ID or any other identifier.
  Future<${className}Model> get$className(/* TODO: Add required params */);
}

/// Concrete implementation of [${className}RemoteDataSource].
class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // TODO: Inject dependencies such as http.Client or Dio
  // final http.Client client;
  // ${className}RemoteDataSourceImpl({required this.client});

  @override
  Future<${className}Model> get$className(/* TODO: Add params */) async {
    // TODO: Replace mock delay and data with actual API logic
    await Future.delayed(const Duration(seconds: 1));

    return ${className}Model(
      // TODO: Provide mock or parsed data here
    );
  }
}
''';

String dataRepoImplTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';

/// Implementation of the [${className}Repository] interface.
/// Responsible for handling business logic and delegating data retrieval to remote sources.
class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;

  ${className}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<$className> get$className(/* TODO: Add required params */) async {
    final remoteData = await remoteDataSource.get$className(/* TODO: Pass params */);

    // TODO: If Model and Entity differ, map Model to Entity here
    return remoteData;
  }
}
''';
