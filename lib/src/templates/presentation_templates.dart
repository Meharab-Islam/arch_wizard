// --- Placeholder Page ---
String pageTemplate(String className) =>
    '''
import 'package:flutter/material.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: const Center(
        child: Text('$className Feature Page - Connect your state management here!'),
      ),
    );
  }
}
''';

// --- BLoC Templates ---
String blocTemplate(String className, String featureName) =>
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_$featureName.dart';
import '${featureName}_event.dart';
import '${featureName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final Get$className get$className;

  ${className}Bloc({required this.get$className}) : super(${className}Initial()) {
    on<Get${className}DetailsEvent>((event, emit) async {
      emit(${className}Loading());
      try {
        final data = await get$className(event.id);
        emit(${className}Loaded(data));
      } catch (e) {
        emit(${className}Error(e.toString()));
      }
    });
  }
}
''';

String blocEventTemplate(String className) =>
    '''
import 'package:equatable/equatable.dart';

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object> get props => [];
}

class Get${className}DetailsEvent extends ${className}Event {
  final String id;
  const Get${className}DetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
''';

String blocStateTemplate(String className) =>
    '''
import 'package:equatable/equatable.dart';
import '../../domain/entities/${className.toLowerCase()}.dart';

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object> get props => [];
}

class ${className}Initial extends ${className}State {}

class ${className}Loading extends ${className}State {}

class ${className}Loaded extends ${className}State {
  final $className data;
  const ${className}Loaded(this.data);

  @override
  List<Object> get props => [data];
}

class ${className}Error extends ${className}State {
  final String message;
  const ${className}Error(this.message);

  @override
  List<Object> get props => [message];
}
''';

// --- GetX Template ---
String getxControllerTemplate(String className, String featureName) =>
    '''
import 'package:get/get.dart';
import '../../domain/usecases/get_$featureName.dart';
import '../../domain/entities/$featureName.dart';

class ${className}Controller extends GetxController {
  final Get$className _get$className;
  ${className}Controller(this._get$className);

  var isLoading = true.obs;
  final $featureName = Rxn<$className>();
  var errorMessage = ''.obs;

  void fetch${className}Details(String id) async {
    try {
      isLoading(true);
      final result = await _get$className(id);
      $featureName(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
''';

// --- Riverpod Template ---
String riverpodTemplate(String className, String featureName) =>
    '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';
// TODO: Make sure your GetIt instance is accessible by importing your injection_container.dart
// import 'package:your_app_name/injection_container.dart'; 
// TODO: Make sure you have Failure classes and the dartz package for Either.
// import 'package:your_app_name/core/error/failures.dart';

/// Provides the UseCase from the GetIt service locator.
///
/// This provider is responsible for bridging the dependency injection setup (GetIt)
/// with Riverpod. It allows other providers to access the business logic layer
/// in a clean, testable way.
final get${className}UseCaseProvider = Provider<Get$className>((ref) {
  // Replace 'sl' with your actual GetIt instance if named differently.
  return sl<Get$className>();
});

/// Fetches the feature details for a given ID and manages the async state.
///
/// This is an auto-disposing, family provider:
/// - `.family` allows you to pass in the changing 'id' parameter.
/// - `.autoDispose` automatically cleans up the provider's state when it's no
///   longer being listened to, saving memory and preventing stale data.
final ${featureName}DetailsProvider = FutureProvider.autoDispose.family<$className, String>((ref, id) async {
  // Watch the use case provider to get an instance of the business logic.
  final useCase = ref.watch(get${className}UseCaseProvider);
  
  // Execute the use case to fetch data.
  final result = await useCase(id);
  
  // Use .fold() to safely handle both failure and success states from the Either type.
  return result.fold(
    // On failure, throw an exception. Riverpod will automatically catch this
    // and expose it as an AsyncError state to the UI.
    (failure) {
      // You can map different failure types to different error messages here.
      // For now, we'll throw a generic exception.
      throw Exception('Failed to load data. Please try again.');
    },
    
    // On success, return the data. Riverpod will expose this as an AsyncData state.
    (data) => data,
  );
});
''';


// --- Provider Template ---
String providerTemplate(String className, String featureName) =>
    '''
import 'package:flutter/material.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';
import '../../../../injection_container.dart';

enum ViewState { initial, loading, loaded, error }

class ${className}Provider extends ChangeNotifier {
  final Get$className _get$className;
  ${className}Provider(this._get$className);

  var _state = ViewState.initial;
  ViewState get state => _state;

  $className? _${featureName}Data;
  $className? get ${featureName}Data => _${featureName}Data;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetch${className}Details(String id) async {
    _state = ViewState.loading;
    notifyListeners();
    
    try {
      _${featureName}Data = await _get$className(id);
      _state = ViewState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    
    notifyListeners();
  }
}
''';

// --- GetIt Registration Template ---
String getItRegistrationTemplate(
  String className,
  String featureName,
  String state,
) {
  String presentationDI;
  switch (state) {
    case 'bloc':
      presentationDI =
          'sl.registerFactory(() => ${className}Bloc(get$className: sl()));';
      break;
    case 'getx':
      presentationDI =
          '// For GetX, you register controllers in a Bindings class:\n// Get.lazyPut(() => ${className}Controller(sl()));';
      break;
    case 'provider':
      presentationDI = 'sl.registerFactory(() => ${className}Provider(sl()));';
      break;
    case 'riverpod':
      presentationDI =
          '// For Riverpod, dependencies are usually injected via ref.watch or other providers.';
      break;
    default:
      presentationDI =
          '// No presentation dependency injection snippet for "$state".';
  }

  return '''
// Feature: $className
//
// Presentation
$presentationDI
//
// Domain
sl.registerLazySingleton(() => Get$className(sl()));
//
// Data
sl.registerLazySingleton<${className}Repository>(
  () => ${className}RepositoryImpl(remoteDataSource: sl()),
);
sl.registerLazySingleton<${className}RemoteDataSource>(
  () => ${className}RemoteDataSourceImpl(),
);
''';
}
