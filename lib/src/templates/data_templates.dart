String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// The data model that extends the domain entity.
class ${className}Model extends $className {
  // The constructor now accepts all required parameters from the parent.
  const ${className}Model({
    required super.id,
    required super.name, // Added 'name' to satisfy the parent
  });

  // The fromJson factory must also be updated to parse all properties.
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'N/A', // Example of handling potential nulls
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
''';

String remoteDataSourceTemplate(String className, String featureName) => '''
import '../models/${featureName}_model.dart';

/// The contract for remote data operations.
abstract class ${className}RemoteDataSource {
  Future<${className}Model> get${className}(String id);
}

/// The implementation of the remote data source.
class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // final http.Client client;
  // ${className}RemoteDataSourceImpl({required this.client});

  @override
  Future<${className}Model> get${className}(String id) async {
    // Simulating a network call.
    await Future.delayed(const Duration(seconds: 1));
    return ${className}Model(id: id);
  }
}
''';

String dataRepoImplTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';

/// The implementation of the domain repository.
class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;
  
  ${className}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<$className> get${className}(String id) async {
    // You can handle mapping from Model to Entity here if they differ.
    final remoteData = await remoteDataSource.get$className(id);
    return remoteData;
  }
}
''';