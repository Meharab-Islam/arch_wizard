String dataModelTemplate(String className, String featureName) => '''
import '../../domain/entities/$featureName.dart';

/// The data model that extends the domain entity.
/// Includes methods for JSON serialization.
class ${className}Model extends $className {
  const ${className}Model({
    required super.id,
    required super.name, // Assuming 'name' also exists in the entity
  });

  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    // Ensure you handle potential null values and type mismatches gracefully.
    return ${className}Model(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'N/A',
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
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/${featureName}_model.dart';
// TODO: Create a file for custom exceptions, e.g., 'core/error/exceptions.dart'
// class ServerException implements Exception {}

/// The contract for remote data operations.
abstract class ${className}RemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<${className}Model> get${className}(String id);
}

/// The implementation of the remote data source.
class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  final http.Client client;
  
  ${className}RemoteDataSourceImpl({required this.client});

  @override
  Future<${className}Model> get${className}(String id) async {
    final response = await client.get(
      Uri.parse('YOUR_API_ENDPOINT/\$id'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return ${className}Model.fromJson(json.decode(response.body));
    } else {
      // Throw a specific exception for easier error handling in the repository.
      throw Exception('Server Failure'); // Replace with your custom ServerException
    }
  }
}
''';


String dataRepoImplTemplate(String className, String featureName) => '''
// TODO: Add dartz package or create your own Either type.
// TODO: Create a Failure class hierarchy, e.g., 'core/error/failures.dart'
// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failures.dart';
// import 'package:your_app/core/error/exceptions.dart';
// import 'package:your_app/core/platform/network_info.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';

/// The implementation of the domain repository.
class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // For checking internet connection

  ${className}RepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future< /* Either<Failure,*/ $className> get${className}(String id) async {
    // if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.get$className(id);
        // On success, return the data on the 'Right' side of Either.
        return /*Right(*/remoteData/*)*/;
      } on Exception { // Catch the specific ServerException
        // On failure, return a Failure object on the 'Left' side.
        return /*Left(ServerFailure())*/;
      }
    // } else {
    //   return Left(NetworkFailure());
    // }
  }
}
''';