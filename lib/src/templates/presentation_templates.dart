/// =============================================================
/// Presentation Layer Templates
/// Author: Meharab Islam Nibir
/// Description:
///   Templates for creating Flutter presentation layer components
///   supporting multiple state management options:
///     - Stateless placeholder page
///     - BLoC (with Failure handling)
///     - GetX Controller
///     - Riverpod Provider
///     - ChangeNotifier Provider
///     - GetIt dependency injection registration
///
/// How to Use:
///   1. Generate your desired template by calling the respective function.
///   2. Place the generated Dart file in the proper presentation folder:
///        - presentation/pages/
///        - presentation/bloc/
///        - presentation/controllers/
///        - presentation/providers/
///   3. Update imports and feature/class names accordingly.
///   4. Connect with your domain layer use cases and entities.
/// =============================================================

/// ------------------------------
/// Placeholder Page Template
/// ------------------------------
/// Usage:
///   - Quick scaffold for a feature page.
/// Customization:
///   - Replace UI widget with your actual design.
///   - Integrate your state management logic here.
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
///   - For features using flutter_bloc package.
///   - Place in presentation/bloc/
/// Customization:
///   - Replace `Get$className` with your actual use case class.
///   - Add extra events and states as needed.
///   - Make sure to handle Either<Failure, Entity> in the use case.
/// ------------------------------
String blocTemplate(String className, String featureName) => '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';
import '${featureName}_event.dart';
import '${featureName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final Get$className get$className;

  ${className}Bloc({required this.get$className}) : super(${className}Initial()) {
    on<Get${className}DetailsEvent>((event, emit) async {
      emit(${className}Loading());
      final Either<Failure, $className> failureOrData = await get$className(event.id);

      failureOrData.fold(
        (failure) => emit(${className}Error(_mapFailureToMessage(failure))),
        (data) => emit(${className}Loaded(data)),
      );
    });
  }

  /// Map Failure types to user-friendly messages.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Cache error occurred. Please try again later.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
''';

/// ------------------------------
/// BLoC Event Template
/// ------------------------------
/// Usage:
///   - Defines the events that trigger state changes in BLoC.
/// Customization:
///   - Add other events specific to your feature if needed.
/// ------------------------------
String blocEventTemplate(String className) => '''
import 'package:equatable/equatable.dart';

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object> get props => [];
}

/// Event to fetch details for a specific $className by ID.
class Get${className}DetailsEvent extends ${className}Event {
  final String id;
  const Get${className}DetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
''';

/// ------------------------------
/// BLoC State Template
/// ------------------------------
/// Usage:
///   - Represents different states of the BLoC lifecycle.
/// Customization:
///   - Add more states if your feature requires.
/// ------------------------------
String blocStateTemplate(String className) => '''
import 'package:equatable/equatable.dart';
import '../../domain/entities/${className.toLowerCase()}.dart';

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class ${className}Initial extends ${className}State {}

/// Loading state while waiting for data.
class ${className}Loading extends ${className}State {}

/// Loaded state with successful data.
class ${className}Loaded extends ${className}State {
  final $className data;
  const ${className}Loaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error state with error message.
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
/// Usage:
///   - For features using GetX state management.
///   - Place in presentation/controllers/
/// Customization:
///   - Replace $featureName with your lowercase entity name.
///   - Extend reactive variables as needed.
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

  /// Fetch details of $className by ID.
  void fetch${className}Details(String id) async {
    try {
      isLoading(true);
      final result = await _get$className(id);
      // Assuming result is Either<Failure, Entity>
      result.fold(
        (failure) => errorMessage(_mapFailureToMessage(failure)),
        (data) => $featureName(data),
      );
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Map failure to user-friendly message.
  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Cache error occurred. Please try again later.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
''';

/// ------------------------------
/// Riverpod Provider Template
/// ------------------------------
/// Usage:
///   - For features using Riverpod.
///   - Place in presentation/providers/
/// Customization:
///   - Replace $featureName with lowercase entity name.
///   - Adjust error messages and handling as needed.
/// ------------------------------
String riverpodTemplate(String className, String featureName) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';
import '../../../../injection_container.dart';

/// Provides the UseCase from GetIt service locator.
final get${className}UseCaseProvider = Provider<Get$className>((ref) {
  return sl<Get$className>();
});

/// Async provider to fetch $className details by ID.
final ${featureName}DetailsProvider =
    FutureProvider.autoDispose.family<Either<Failure, $className>, String>((ref, id) async {
  final useCase = ref.watch(get${className}UseCaseProvider);
  return await useCase(id);
});

/// Extension method to convert Either<Failure, T> to user-friendly message or data.
/// Use `.when` on your UI layer to handle loading, error, or data states.
''';

/// ------------------------------
/// ChangeNotifier Provider Template
/// ------------------------------
/// Usage:
///   - For features using ChangeNotifier Provider.
///   - Place in presentation/providers/
/// ------------------------------
String providerTemplate(String className, String featureName) => '''
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_$featureName.dart';

enum ViewState { initial, loading, loaded, error }

class ${className}Provider extends ChangeNotifier {
  final Get$className _get$className;
  ${className}Provider(this._get$className);

  var _state = ViewState.initial;
  ViewState get state => _state;

  Either<Failure, $className>? _${featureName}Data;
  Either<Failure, $className>? get ${featureName}Data => _${featureName}Data;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Fetch details for $className by ID.
  Future<void> fetch${className}Details(String id) async {
    _state = ViewState.loading;
    notifyListeners();

    final result = await _get$className(id);
    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = ViewState.error;
      },
      (data) {
        _${featureName}Data = Right(data);
        _state = ViewState.loaded;
      },
    );

    notifyListeners();
  }

  /// Map failure to user-friendly message.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Cache error occurred. Please try again later.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
''';

/// ------------------------------
/// GetIt Dependency Injection Registration Template
/// ------------------------------
/// Usage:
///   - Add these registrations to your injection_container.dart
///   - Adjust registrations as per your state management approach.
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
