/// =============================================================
/// Presentation Layer Templates
/// Author: Meharab Islam Nibir
/// Description:
///   Templates for creating Flutter presentation layer components
///   with multiple state management options:
///     - Stateless placeholder page
///     - BLoC
///     - GetX
///     - Riverpod
///     - Provider
///     - GetIt registration
/// 
/// How to Use:
///   1. Generate the desired template using the function.
///   2. Place the generated file in the correct `presentation/` subfolder:
///        presentation/pages/
///        presentation/bloc/
///        presentation/controllers/
///        presentation/providers/
///   3. Update imports, class names, and dependencies as per your project.
///   4. Connect with domain layer use cases.
/// =============================================================

/// ------------------------------
/// Placeholder Page
/// ------------------------------
/// Usage:
///   - Scaffolds a new feature page.
///   - Replace `$className` with your feature name.
/// Customization:
///   - Replace UI with actual design and widgets.
///   - Connect your state management solution.
/// ------------------------------
String pageTemplate(String className) => '''
import 'package:flutter/material.dart';

/// Placeholder page for the $className feature.
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

/// ------------------------------
/// BLoC Template
/// ------------------------------
/// Usage:
///   - For features using flutter_bloc.
///   - Place in `presentation/bloc/`.
/// Customization:
///   - Replace `Get$className` with your actual use case.
///   - Add more events and states as needed.
/// ------------------------------
String blocTemplate(String className, String featureName) => '''
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

String blocEventTemplate(String className) => '''
import 'package:equatable/equatable.dart';

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object> get props => [];
}

/// Event to fetch details for a specific $className.
class Get${className}DetailsEvent extends ${className}Event {
  final String id;
  const Get${className}DetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
''';

String blocStateTemplate(String className) => '''
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

/// ------------------------------
/// GetX Controller Template
/// ------------------------------
/// Usage:
///   - For features using GetX.
///   - Place in `presentation/controllers/`.
/// Customization:
///   - Replace `$featureName` with actual lowercase entity name.
///   - Add extra reactive variables as needed.
/// ------------------------------
String getxControllerTemplate(String className, String featureName) => '''
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

/// ------------------------------
/// Riverpod Template
/// ------------------------------
/// Usage:
///   - For features using Riverpod.
///   - Place in `presentation/providers/`.
/// Customization:
///   - Replace `$featureName` with actual lowercase entity name.
///   - Adjust error handling as needed.
/// ------------------------------
String riverpodTemplate(String className, String featureName) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';
import '../../../../injection_container.dart';

/// Provides the UseCase from GetIt (Service Locator).
final get${className}UseCaseProvider = Provider<Get$className>((ref) {
  return sl<Get$className>();
});

/// Async provider for fetching $className details by ID.
final ${featureName}DetailsProvider =
    FutureProvider.autoDispose.family<$className, String>((ref, id) async {
  final useCase = ref.watch(get${className}UseCaseProvider);

  try {
    return await useCase(id);
  } catch (e) {
    throw Exception('Failed to load data: \${e.toString()}');
  }
});
''';

/// ------------------------------
/// Provider Template
/// ------------------------------
/// Usage:
///   - For features using ChangeNotifier Provider.
///   - Place in `presentation/providers/`.
/// ------------------------------
String providerTemplate(String className, String featureName) => '''
import 'package:flutter/material.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';

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

/// ------------------------------
/// GetIt Registration Template
/// ------------------------------
/// Usage:
///   - Add to your dependency injection setup file (`injection_container.dart`).
///   - Adjust per state management type.
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
          'sl.registerFactory(() => ${className}Bloc(get$className: sl()));';
      break;
    case 'getx':
      presentationDI =
          '// For GetX, register controllers in Bindings:\n// Get.lazyPut(() => ${className}Controller(sl()));';
      break;
    case 'provider':
      presentationDI = 'sl.registerFactory(() => ${className}Provider(sl()));';
      break;
    case 'riverpod':
      presentationDI =
          '// For Riverpod, dependencies are injected via ref.watch() or providers.';
      break;
    default:
      presentationDI =
          '// No presentation DI snippet for "$state".';
  }

  return '''
// Feature: $className

// ---------------- Presentation ----------------
$presentationDI

// ---------------- Domain ----------------
sl.registerLazySingleton(() => Get$className(sl()));

// ---------------- Data ----------------
sl.registerLazySingleton<${className}Repository>(
  () => ${className}RepositoryImpl(remoteDataSource: sl()),
);
sl.registerLazySingleton<${className}RemoteDataSource>(
  () => ${className}RemoteDataSourceImpl(),
);
''';
}
