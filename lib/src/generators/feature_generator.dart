import 'dart:io';
import '../templates/domain_templates.dart';
import '../templates/data_templates.dart';
import '../templates/presentation_templates.dart';
import '../utils/file_modifier.dart';
import '../utils/logger.dart';

Future<void> generateFeature(String name, String state) async {
  final featureName = name.toLowerCase();
  final className = _capitalize(featureName);

  // Define paths
  final featureDir = 'lib/features/$featureName';
  final domainDir = '$featureDir/domain';
  final dataDir = '$featureDir/data';
  final presentationDir = '$featureDir/presentation';

  // Create directories
  await _createDirs([
    '$domainDir/entities', '$domainDir/repositories', '$domainDir/usecases',
    '$dataDir/datasources', '$dataDir/models', '$dataDir/repositories',
    '$presentationDir/pages', '$presentationDir/widgets',
  ]);

  // Create Domain Layer
  await _createFile('$domainDir/entities/$featureName.dart', domainEntityTemplate(className));
  await _createFile('$domainDir/repositories/${featureName}_repository.dart', domainRepoTemplate(className));
  await _createFile('$domainDir/usecases/get_${featureName}.dart', useCaseTemplate(className, featureName));
  
  // Create Data Layer
  await _createFile('$dataDir/models/${featureName}_model.dart', dataModelTemplate(className, featureName));
  await _createFile('$dataDir/datasources/${featureName}_remote_data_source.dart', remoteDataSourceTemplate(className, featureName));
  await _createFile('$dataDir/repositories/${featureName}_repository_impl.dart', dataRepoImplTemplate(className, featureName));

  // Create Presentation Layer
  await _generatePresentationLayer(presentationDir, featureName, className, state);
  
  // Create UI Page
  await _createFile('$presentationDir/pages/${featureName}_page.dart', pageTemplate(className));

  // Automate DI Registration
  logger.info('\nAttempting to auto-register dependencies...');
  await registerDependencies(
    'lib/injection_container.dart', // Or your DI file path
    getItRegistrationTemplate(className, featureName, state),
  );
}

Future<void> _generatePresentationLayer(String presentationDir, String featureName, String className, String state) async {
  final stateDir = '$presentationDir/${_getStateDirName(state)}';
  await _createDirs([stateDir]);

  switch (state.toLowerCase()) {
    case 'bloc':
      await _createFile('$stateDir/${featureName}_bloc.dart', blocTemplate(className, featureName));
      await _createFile('$stateDir/${featureName}_event.dart', blocEventTemplate(className));
      await _createFile('$stateDir/${featureName}_state.dart', blocStateTemplate(className));
      break;
    case 'riverpod':
      await _createFile('$stateDir/${featureName}_provider.dart', riverpodTemplate(className, featureName));
      break;
    case 'getx':
      await _createFile('$stateDir/${featureName}_controller.dart', getxControllerTemplate(className, featureName));
      break;
    case 'provider':
      await _createFile('$stateDir/${featureName}_provider.dart', providerTemplate(className, featureName));
      break;
  }
}

// Helper Functions
Future<void> _createDirs(List<String> dirs) async {
  for (final dir in dirs) {
    await Directory(dir).create(recursive: true);
  }
}

Future<void> _createFile(String path, String content) async {
  await File(path).writeAsString(content);
}

String _getStateDirName(String state) {
  switch(state) {
    case 'getx': return 'controllers';
    case 'bloc': return 'bloc';
    default: return 'providers';
  }
}

String _capitalize(String s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);