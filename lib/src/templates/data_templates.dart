/// =============================================================
/// Clean Architecture Code Generation Templates
/// Author: Meharab Islam Nibir
///
/// Description:
///   These templates scaffold Data Models, Remote Data Sources,
///   and Repository Implementations following Clean Architecture.
///   They support Either<Failure, Entity> error handling.
///
/// How to use:
///   1. Replace `className` with the PascalCase entity name (e.g., User).
///   2. Replace `featureName` with lowercase or snake_case feature name (e.g., user).
///   3. Customize fields, fromJson/toJson, and data source logic as needed.
/// =============================================================

/// =============================================================
/// Data Model Template
/// =============================================================
String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// Data model for [$className], extending the domain entity.
/// 
/// TODO:
/// - Add all relevant fields matching your backend data.
/// - Update fromJson/toJson methods for serialization.
/// - You can add helper methods if needed.
class ${className}Model extends $className {
  const ${className}Model({
    required super.id,
    // TODO: Add other fields here as required.
  });

  /// Creates a model from a JSON map.
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as String,
      // TODO: Map other fields from JSON here.
    );
  }

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // TODO: Add other fields here.
    };
  }
}
''';

/// =============================================================
/// Remote Data Source Template
/// =============================================================
String remoteDataSourceTemplate(String className, String featureName) => '''
import '../models/${featureName}_model.dart';

/// Abstract remote data source contract for [$className].
/// 
/// TODO:
/// - Implement this interface with your actual API or Firebase calls.
/// - This layer should return Data Models, not domain entities.
/// - You can add caching or retry logic here if needed.
abstract class ${className}RemoteDataSource {
  /// Fetch a [$className] model by ID from remote source.
  Future<${className}Model> get$className(String id);
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // Example: Uncomment and inject your API client, e.g., Dio
  // final Dio dio;
  // ${className}RemoteDataSourceImpl(this.dio);

  @override
  Future<${className}Model> get$className(String id) async {
    // TODO: Replace this with actual API or Firebase logic
    // Example for REST API:
    // final response = await dio.get('/$featureName/\$id');
    // return ${className}Model.fromJson(response.data);

    // Simulated delay & dummy return for scaffold
    await Future.delayed(const Duration(seconds: 1));
    return ${className}Model(id: id);
  }
}
''';

/// =============================================================
/// Repository Implementation Template
/// =============================================================
String dataRepoImplTemplate(String className, String featureName) => '''
import 'package:dartz/dartz.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_mapper.dart';
import '../datasources/${featureName}_remote_data_source.dart';

/// Repository implementation for [$className].
///
/// This bridges domain and data layers:
/// - Fetches data from remote data source,
/// - Converts models to entities,
/// - Wraps results inside Either<Failure, Entity>.
class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;

  const ${className}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, $className>> get$className(String id) async {
    try {
      final remoteData = await remoteDataSource.get$className(id);

      // NOTE:
      // If your model extends your entity, you can return directly.
      // Otherwise, convert the model to the domain entity here.
      return Right(remoteData);

    } catch (e) {
      // Use FailureMapper to convert exceptions to Failure objects.
      Failure failure;
      if (e is Exception) {
        failure = FailureMapper.mapExceptionToFailure(e);
      } else {
        failure = GenericFailure(e.toString());
      }
      return Left(failure);
    }
  }
}
''';
