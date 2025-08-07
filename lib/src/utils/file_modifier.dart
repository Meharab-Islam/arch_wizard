import 'dart:io';
import 'package:arch_wizard/src/utils/logger.dart';

/// A marker to find the injection point in the DI file.
const String diMarker = '// [DI_GENERATE_HERE]';

Future<void> registerDependencies(String diFilePath,String import,  String newRegistrations) async {
  final diFile = File(diFilePath);
  if (!await diFile.exists()) {
    logger.warn('Warning: Dependency injection file not found at "$diFilePath".');
    logger.warn('Please add the following registrations manually:');
    logger.info(import);
    logger.info(newRegistrations);
    return;
  }

  try {
    String content = await diFile.readAsString();
    if (content.contains(diMarker)) {
      content = content.replaceFirst(diMarker, '$newRegistrations\n$diMarker');
      await diFile.writeAsString(content);
      logger.success('✅ Dependencies registered automatically in "$diFilePath".');
    } else {
      logger.warn('Warning: Marker "$diMarker" not found in "$diFilePath".');
      logger.warn('Please add the marker to your DI file to enable auto-registration.');
      logger.info('Registrations to add manually:\n$newRegistrations');
    }
  } catch (e) {
    logger.err('Failed to write to DI file: $e');
  }
}