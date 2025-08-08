/// =============================================================
/// Code Generation Templates for Clean Architecture in Flutter
/// Author: Meharab Islam Nibir
/// Description:
///   This file provides customizable string templates for
///   Data Models, Remote Data Sources, and Repository Implementations
///   following Clean Architecture principles.
/// 
///   Usage:
///     - Use these templates to quickly scaffold feature layers.
///     - Replace placeholders (className, featureName) accordingly.
///     - Extend/modify templates for specific project requirements.
///
///   Layers covered:
///     1. Data Model
///     2. Remote Data Source
///     3. Repository Implementation
/// =============================================================

/// ------------------------------
/// Data Model Template
/// ------------------------------
/// Parameters:
///   - className: The name of the domain entity (e.g., `User`)
///   - featureName: The lowercase feature name (e.g., `user`)
///
/// Customization Points:
///   - Add/modify constructor fields as per entity properties.
///   - Update `fromJson` and `toJson` mappings accordingly.
/// ------------------------------
String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// Data model extending the domain entity [$className].
/// Used for converting raw API data (JSON) into a strongly-typed object.
class ${className}Model extends $className {
  /// Constructor mapping all required fields from the domain entity.
  const ${className}Model({
    required super.id,
    // Add other parameters here...
  });

  /// Factory constructor to create a model instance from JSON.
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as String,
      // Map other properties here...
    );
  }

  /// Converts the model into a JSON map for API consumption.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Add other mappings here...
    };
  }
}
''';

/// ------------------------------
/// Remote Data Source Template
/// ------------------------------
/// Parameters:
///   - className: The name of the domain entity (e.g., `User`)
///   - featureName: The lowercase feature name (e.g., `user`)
///
/// Customization Points:
///   - Replace simulated network call with actual API request logic.
///   - Inject dependencies (e.g., http.Client, Dio) for real API calls.
/// ------------------------------
String remoteDataSourceTemplate(String className, String featureName) => '''
import '../models/${featureName}_model.dart';

/// Abstract contract for remote data operations of [$className].
abstract class ${className}RemoteDataSource {
  Future<${className}Model> get$className(String id);
}

/// Implementation of the remote data source.
/// Replace simulated call with actual HTTP request in production.
class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // Example: Uncomment to use an HTTP client
  // final http.Client client;
  // ${className}RemoteDataSourceImpl({required this.client});

  @override
  Future<${className}Model> get$className(String id) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // Replace this with actual API response parsing
    return ${className}Model(id: id);
  }
}
''';

/// ------------------------------
/// Repository Implementation Template
/// ------------------------------
/// Parameters:
///   - className: The name of the domain entity (e.g., `User`)
///   - featureName: The lowercase feature name (e.g., `user`)
///
/// Customization Points:
///   - Add mapping logic if your model differs from the entity.
///   - Add caching, error handling, or offline-first logic here.
/// ------------------------------
String dataRepoImplTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';

/// Repository implementation for [$className].
/// Handles communication between domain layer and remote data sources.
class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;

  const ${className}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<$className> get$className(String id) async {
    // Fetch from remote data source
    final remoteData = await remoteDataSource.get$className(id);

    // Optional: Add mapping from Model to Entity if needed
    return remoteData;
  }
}
''';
