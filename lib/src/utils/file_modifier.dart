import 'dart:io';
import 'package:arch_wizard/src/utils/logger.dart';

const String importMarker = '// [IMPORT_GENERATE_HERE]';
const String diMarker = '// [DI_GENERATE_HERE]';

/// The default content for a newly created injection container file.
const String diFileTemplate = '''
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// The Arch Wizard will add new import statements right below this line.
// [IMPORT_GENERATE_HERE]

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => http.Client());

  //! Features
  // The Arch Wizard will add new feature dependencies right below this line.
  // [DI_GENERATE_HERE]
}
''';

/// Registers both imports and dependencies in the specified DI file.
/// If the file doesn't exist, it creates it automatically.
Future<void> registerDependencies(
  String diFilePath,
  String newImports,
  String newRegistrations,
) async {
  final diFile = File(diFilePath);

  if (!await diFile.exists()) {
    logger.info('File "$diFilePath" not found. Creating it now...');
    try {
      await diFile.create(recursive: true);
      await diFile.writeAsString(diFileTemplate);
      logger.success('✅ Created "$diFilePath" successfully.');
      logger.warn(
        'Please remember to call the init() function in your main.dart file!',
      );
    } catch (e) {
      logger.err('Failed to create "$diFilePath": $e');
      return;
    }
  }

  try {
    String content = await diFile.readAsString();
    bool modified = false;

    // Handle Imports
    if (content.contains(importMarker)) {
      content = content.replaceFirst(importMarker, '$newImports\n$importMarker');
      modified = true;
    } else {
      logger.warn('Warning: Import marker "$importMarker" not found.');
    }

    // Handle Registrations
    if (content.contains(diMarker)) {
      content = content.replaceFirst(diMarker, '$newRegistrations\n$diMarker');
      modified = true;
    } else {
      logger.warn('Warning: DI registration marker "$diMarker" not found.');
    }

    if (modified) {
      await diFile.writeAsString(content, flush: true);
      logger.success('✅ Dependencies and imports registered automatically.');
    } else {
      logger.warn('No markers found. Could not auto-inject dependencies.');
    }
  } catch (e) {
    logger.err('Failed to write to DI file: $e');
  }
}
