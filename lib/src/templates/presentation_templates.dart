/// =============================================================
/// Presentation Layer Templates
/// Author: Meharab Islam Nibir
/// Description:
///   Generic templates for Flutter presentation components.
///   Includes guidance comments instead of actual API calls.
/// =============================================================

/// ------------------------------
/// Placeholder Page Template
/// ------------------------------
String pageTemplate(String className) => '''
import 'package:flutter/material.dart';

/// Placeholder page for the $className feature.
/// Customize this page as needed.
class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: const Center(
        child: Text('$className Feature Page - Customize your UI and state management here!'),
      ),
    );
  }
}
''';

/// ------------------------------
/// BLoC Template
/// ------------------------------
String blocTemplate(String className, String featureName) => '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';
import '${featureName}_event.dart';
import '${featureName}_state.dart';

/// BLoC for $className feature.
/// Customize the event handlers and add your API/use case calls.
class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  // Inject your UseCases here via constructor
  // final YourUseCase yourUseCase;

  ${className}Bloc() : super(${className}Initial()) {
    on<${className}Event>((event, emit) async {
      emit(${className}Loading());
      
      // TODO: Add your API/use case call logic here.
      try {
        // final data = await yourUseCase.call(...);
        // emit(${className}Loaded(data));

        // Placeholder: emit loaded with no data.
        emit(${className}Loaded(/* pass your data here */"pass your data here"));
      } catch (error) {
        emit(${className}Error('Failed to fetch data. Customize this message.'));
      }
    });
  }
}
''';

/// ------------------------------
/// BLoC Event Template
/// ------------------------------
String blocEventTemplate(String className) => '''
import 'package:equatable/equatable.dart';

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object> get props => [];
}

/// Example event to fetch data. Customize or add more events as needed.
class Fetch${className}Event extends ${className}Event {}
''';

/// ------------------------------
/// BLoC State Template
/// ------------------------------
String blocStateTemplate(String className) => '''
import 'package:equatable/equatable.dart';
import '../../domain/entities/${className.toLowerCase()}.dart';

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

class ${className}Initial extends ${className}State {}

class ${className}Loading extends ${className}State {}

class ${className}Loaded extends ${className}State {
  final dynamic data; // Replace dynamic with your actual data type
  const ${className}Loaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ${className}Error extends ${className}State {
  final String message;
  const ${className}Error(this.message);

  @override
  List<Object?> get props => [message];
}
''';

/// ------------------------------
/// GetX Controller Template
/// ------------------------------
String getxControllerTemplate(String className, String featureName) => '''
import 'package:get/get.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';

/// GetX controller for $className feature.
/// Customize fetch methods and state management as needed.
class ${className}Controller extends GetxController {
  var isLoading = false.obs;
  var data = Rxn<$className>();
  var errorMessage = ''.obs;

  /// Example fetch method. Replace with your actual API or use case call.
  void fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // TODO: Call your API or use case here
      // data.value = await yourUseCase.call(...);

      // Placeholder data value (null)
      data.value = null;
    } catch (e) {
      errorMessage.value = 'Error fetching data. Customize this message.';
    } finally {
      isLoading.value = false;
    }
  }
}
''';

/// ------------------------------
/// Riverpod Provider Template
/// ------------------------------
String riverpodTemplate(String className, String featureName) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';

/// Riverpod provider for $className feature.
/// Customize the async provider with your API or use case call.
final ${featureName}Provider = FutureProvider.autoDispose<$className>((ref) async {
  // TODO: Fetch data here using your use case or repository
  // Example: return await ref.read(yourUseCaseProvider).call(...);

  // Placeholder: return null or throw an error as needed
  throw UnimplementedError('Implement data fetching logic');
});
''';

/// ------------------------------
/// ChangeNotifier Provider Template
/// ------------------------------
String providerTemplate(String className, String featureName) => '''
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';

enum ViewState { initial, loading, loaded, error }

class ${className}Provider extends ChangeNotifier {
  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  $className? data;
  String errorMessage = '';

  /// Fetch data method - customize this with your API call or use case.
  Future<void> fetchData() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      // TODO: Call your API/use case here
      // Example:
      // data = await yourUseCase.call(...);

      // Placeholder data
      data = null;
      _state = ViewState.loaded;
    } catch (e) {
      errorMessage = 'Error occurred. Customize this message.';
      _state = ViewState.error;
    }

    notifyListeners();
  }
}
''';

/// ------------------------------
/// GetIt Dependency Injection Registration Template
/// ------------------------------
String getItRegistrationTemplate(
  String className,
  String featureName,
  String state,
) {
  String presentationDI;
  switch (state) {
    case 'bloc':
      presentationDI =
          'sl.registerFactory(() => ${className}Bloc()); // TODO: Add your use case to constructor';
      break;
    case 'getx':
      presentationDI =
          '// For GetX, register controllers in Bindings:\n// Get.lazyPut(() => ${className}Controller());';
      break;
    case 'provider':
      presentationDI = 'sl.registerFactory(() => ${className}Provider());';
      break;
    case 'riverpod':
      presentationDI =
          '// For Riverpod, dependencies are injected via providers.';
      break;
    default:
      presentationDI = '// No presentation DI snippet for "$state".';
  }

  return '''
// Feature: $className

// ---------------- Presentation ----------------
$presentationDI

// ---------------- Domain ----------------
// TODO: Register your domain use cases here.
// sl.registerLazySingleton(() => Get$className(sl()));

// ---------------- Data ----------------
// TODO: Register your repository and data sources here.
// sl.registerLazySingleton<${className}Repository>(
//   () => ${className}RepositoryImpl(remoteDataSource: sl()),
// );
// sl.registerLazySingleton<${className}RemoteDataSource>(
//   () => ${className}RemoteDataSourceImpl(),
// );
''';
}
