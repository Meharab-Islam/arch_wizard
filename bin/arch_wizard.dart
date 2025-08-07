import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:arch_wizard/src/commands/create_feature_command.dart';
import 'package:arch_wizard/src/utils/logger.dart';

void main(List<String> args) async {
  final runner = CommandRunner<void>(
    'arch_wizard',
    'A CLI tool to scaffold Flutter clean architecture features.',
  )..addCommand(CreateFeatureCommand());

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    logger.err(e.message);
    logger.info(e.usage);
    exit(64); // Exit code for command-line usage error
  } catch (e) {
    logger.err('An unexpected error occurred: $e');
    exit(1);
  }
}
