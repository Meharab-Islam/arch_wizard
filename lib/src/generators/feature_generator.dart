import 'dart:io';
import 'package:arch_wizard/src/templates/failure_templates.dart';
import 'package:arch_wizard/src/templates/import_templates.dart';

import '../templates/domain_templates.dart';
import '../templates/data_templates.dart';
import '../templates/presentation_templates.dart';
import '../utils/file_modifier.dart';
import '../utils/logger.dart';

/// Path for feature generation error log
const String featureErrorLogPath = 'feature_generation_error.log';

/// Writes an error message with timestamp to the error log file.
/// Appends to existing file or creates a new one.
Future<void> _writeErrorLog(String message) async {
  final logFile = File(featureErrorLogPath);
  final timestamp = DateTime.now().toIso8601String();
  final fullMessage = '[$timestamp] $message\n';

  try {
    await logFile.writeAsString(fullMessage, mode: FileMode.append);
  } catch (e) {
    // If writing the log fails, fallback to console only
    logger.err('Failed to write to feature error log file: $e');
  }
}

/// The main orchestrator for generating a new feature.
Future<void> generateFeature(String name, String state) async {
  final featureName = name.toLowerCase();
  final className = _capitalize(featureName);

  final packageName = await _getPackageName();
  if (packageName == null) {
    const msg = 'Could not find package name in pubspec.yaml. Aborting.';
    logger.err(msg);
    await _writeErrorLog(msg);
    exit(1);
  }

  // Generate core failure files (once)
  await _generateCoreFailures();

  // Define paths
  final featureDir = 'lib/features/$featureName';
  final domainDir = '$featureDir/domain';
  final dataDir = '$featureDir/data';
  final presentationDir = '$featureDir/presentation';

  // Create all necessary directories
  await _createDirs([
    '$domainDir/entities',
    '$domainDir/repositories',
    '$domainDir/usecases',
    '$dataDir/datasources',
    '$dataDir/models',
    '$dataDir/repositories',
    '$presentationDir/pages',
    '$presentationDir/widgets',
  ]);

  // Generate files for each layer
  await _generateDomainLayer(domainDir, featureName, className);
  await _generateDataLayer(dataDir, featureName, className);
  await _generatePresentationLayer(
    presentationDir,
    featureName,
    className,
    state,
  );

  // Automate DI Registration with Imports
  logger.info('\nAttempting to auto-register dependencies and imports...');
  final imports = importTemplate(packageName, featureName, state);
  final registrations = getItRegistrationTemplate(
    className,
    featureName,
    state,
  );

  await registerDependencies(
    'lib/injection_container.dart',
    imports,
    registrations,
  );
}

/// Creates core failure handling files if they don't already exist.
Future<void> _generateCoreFailures() async {
  const baseDir = 'lib/core/error';

  await _createDirs([baseDir]);

  final failureFile = File('$baseDir/failures.dart');
  if (!await failureFile.exists()) {
    await failureFile.writeAsString(failureTemplate());
    logger.detail('  ✓ Created $baseDir/failures.dart');
  }

  final mapperFile = File('$baseDir/failure_mapper.dart');
  if (!await mapperFile.exists()) {
    await mapperFile.writeAsString(failureMapperTemplate());
    logger.detail('  ✓ Created $baseDir/failure_mapper.dart');
  }
}

/// Creates all files for the Domain layer.
Future<void> _generateDomainLayer(
  String domainDir,
  String featureName,
  String className,
) async {
  logger.info('Generating Domain Layer...');
  await _createFile(
    '$domainDir/entities/$featureName.dart',
    domainEntityTemplate(className),
  );
  await _createFile(
    '$domainDir/repositories/${featureName}_repository.dart',
    domainRepoTemplate(className),
  );
  await _createFile(
    '$domainDir/usecases/get_$featureName.dart',
    useCaseTemplate(className, featureName),
  );
}

/// Creates all files for the Data layer.
Future<void> _generateDataLayer(
  String dataDir,
  String featureName,
  String className,
) async {
  logger.info('Generating Data Layer...');
  await _createFile(
    '$dataDir/models/${featureName}_model.dart',
    dataModelTemplate(className, featureName),
  );
  await _createFile(
    '$dataDir/datasources/${featureName}_remote_data_source.dart',
    remoteDataSourceTemplate(className, featureName),
  );
  await _createFile(
    '$dataDir/repositories/${featureName}_repository_impl.dart',
    dataRepoImplTemplate(className, featureName),
  );
}

/// Creates all files for the Presentation layer based on the chosen state management.
Future<void> _generatePresentationLayer(
  String presentationDir,
  String featureName,
  String className,
  String state,
) async {
  logger.info('Generating Presentation Layer for ${state.toUpperCase()}...');
  final stateDir = '$presentationDir/${_getStateDirName(state)}';
  await _createDirs([stateDir]);

  switch (state.toLowerCase()) {
    case 'bloc':
      await _createFile(
        '$stateDir/${featureName}_bloc.dart',
        blocTemplate(className, featureName),
      );
      await _createFile(
        '$stateDir/${featureName}_event.dart',
        blocEventTemplate(className),
      );
      await _createFile(
        '$stateDir/${featureName}_state.dart',
        blocStateTemplate(className),
      );
      break;
    case 'riverpod':
      await _createFile(
        '$stateDir/${featureName}_provider.dart',
        riverpodTemplate(className, featureName),
      );
      break;
    case 'getx':
      await _createFile(
        '$stateDir/${featureName}_controller.dart',
        getxControllerTemplate(className, featureName),
      );
      break;
    case 'provider':
      await _createFile(
        '$stateDir/${featureName}_provider.dart',
        providerTemplate(className, featureName),
      );
      break;
    default:
      final msg = 'Unknown state management "$state" provided.';
      logger.err(msg);
      await _writeErrorLog(msg);
      break;
  }
  // Also create the main page file for the feature
  await _createFile(
    '$presentationDir/pages/${featureName}_page.dart',
    pageTemplate(className),
  );
}

// --- Helper Functions ---

Future<String?> _getPackageName() async {
  final pubspec = File('pubspec.yaml');
  if (await pubspec.exists()) {
    final lines = await pubspec.readAsLines();
    for (final line in lines) {
      // A more robust regex to find 'name:' and ignore comments
      final match = RegExp(r'^\s*name:\s*(\S+)\s*$').firstMatch(line);
      if (match != null) {
        return match.group(1);
      }
    }
  }
  return null;
}

Future<void> _createDirs(List<String> dirs) async {
  for (final dir in dirs) {
    try {
      await Directory(dir).create(recursive: true);
    } catch (e) {
      final msg = 'Failed to create directory "$dir": $e';
      logger.err(msg);
      await _writeErrorLog(msg);
    }
  }
}

Future<void> _createFile(String path, String content) async {
  try {
    await File(path).writeAsString(content);
    // Provide detailed feedback to the user for each created file.
    logger.detail('  ✓ Created $path');
  } catch (e) {
    final msg = 'Failed to create file $path: $e';
    logger.err(msg);
    await _writeErrorLog(msg);
  }
}

String _getStateDirName(String state) {
  switch (state) {
    case 'getx':
      return 'controllers';
    case 'bloc':
      return 'bloc';
    default:
      return 'providers';
  }
}

String _capitalize(String s) =>
    s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);

/// Failure template string for failure class (lib/core/error/failures.dart)
