/// =============================================================
/// Clean Architecture Code Generation Templates
/// Author: Meharab Islam Nibir
/// 
/// Description:
///   This file provides **ready-to-use, customizable** string
///   templates for quickly scaffolding:
///     1. Data Models
///     2. Remote Data Sources
///     3. Repository Implementations
/// 
///   These templates are designed to work with:
///     - REST API (Dio, http, Chopper, etc.)
///     - Firebase Firestore/Realtime Database
///     - Local Storage (Hive, SQflite)
/// 
///   They follow Clean Architecture principles and support
///   Either<Failure, Entity> error handling.
///
/// How to use:
///   1. Replace `className` with the **PascalCase** name of your entity.
///      Example: `User`
///   2. Replace `featureName` with the **snake_case** or lowercase feature name.
///      Example: `user`
///   3. Adjust fields, fromJson/toJson, and data source logic as needed.
/// =============================================================

/// =============================================================
/// Data Model Template
/// =============================================================
/// 
/// Purpose:
///   Represents the API/Firebase data format but extends the
///   domain entity so that you can pass it into the domain layer
///   without extra conversion.
/// 
/// Customization Points:
///   - Add fields that match your backend response.
///   - Update `fromJson` and `toJson` mappings accordingly.
/// -------------------------------------------------------------
String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// Data model for [$className] extending the domain entity.
class ${className}Model extends $className {
  const ${className}Model({
    required super.id,
    // Add other entity fields here...
  });

  /// Creates a model from JSON.
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as String,
      // Map other fields here...
    );
  }

  /// Converts model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Add other mappings here...
    };
  }
}
''';

/// =============================================================
/// Remote Data Source Template
/// =============================================================
/// 
/// Purpose:
///   Acts as the single source of truth for **remote** data.
///   Can be connected to REST APIs, Firebase, or GraphQL.
/// 
/// Notes:
///   - Always return **models**, not entities.
///   - The repository will decide how to handle data.
///   - Implement caching or retry logic here if needed.
/// -------------------------------------------------------------
String remoteDataSourceTemplate(String className, String featureName) => '''
import '../models/${featureName}_model.dart';

/// Contract for remote operations of [$className].
abstract class ${className}RemoteDataSource {
  Future<${className}Model> get$className(String id);
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // Example for REST:
  // final Dio dio;
  // ${className}RemoteDataSourceImpl(this.dio);

  @override
  Future<${className}Model> get$className(String id) async {
    // TODO: Replace with actual API/Firebase call
    // Example for REST:
    // final response = await dio.get('/$featureName/\$id');
    // return ${className}Model.fromJson(response.data);

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
    return ${className}Model(id: id);
  }
}
''';

/// =============================================================
/// Repository Implementation Template
/// =============================================================
/// 
/// Purpose:
///   Bridges the **domain** and **data** layers.
///   Converts model results into entities and wraps them inside
///   Either<Failure, Entity> for error handling.
/// 
/// Notes:
///   - Inject the remote data source.
///   - Handle exceptions and map them to Failure.
///   - Add caching, offline-first logic if needed.
/// -------------------------------------------------------------
String dataRepoImplTemplate(String className, String featureName) => '''
import 'package:dartz/dartz.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../../../core/error/failures.dart';
import '../datasources/${featureName}_remote_data_source.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;

  const ${className}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, $className>> get$className(String id) async {
    try {
      final remoteData = await remoteDataSource.get$className(id);
      return Right(remoteData);
    } catch (e) {
      // TODO: Map exceptions to a specific Failure type
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
''';
