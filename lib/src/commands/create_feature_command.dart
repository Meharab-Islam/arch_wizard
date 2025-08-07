import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:arch_wizard/src/generators/feature_generator.dart';
import 'package:arch_wizard/src/utils/logger.dart';

class CreateFeatureCommand extends Command<void> {
  @override
  final name = 'create_feature';
  @override
  final description = 'Creates a new feature with a clean architecture structure.';

  CreateFeatureCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'The name of the feature (e.g., login).', mandatory: true)
      ..addOption(
        'state',
        abbr: 's',
        help: 'State management solution.',
        allowed: ['bloc', 'riverpod', 'getx', 'provider'],
        defaultsTo: 'bloc',
      );
  }

  @override
  void run() async {
    // Safety Check: Ensure command is run in a Flutter project root.
    if (!File('pubspec.yaml').existsSync() || !File('pubspec.yaml').readAsStringSync().contains('sdk: flutter')) {
      logger.err('Error: This command must be run from the root of a Flutter project.');
      exit(1);
    }
    
    final featureName = argResults?['name'] as String;
    final stateManagement = argResults?['state'] as String;

    final progress = logger.progress('Generating feature: $featureName');
    try {
      await generateFeature(featureName, stateManagement);
      progress.complete('✅ Feature "$featureName" generated successfully!');
    } catch (e) {
      progress.fail('Failed to generate feature: $e');
      exit(1);
    }
  }
}