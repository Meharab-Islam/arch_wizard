// FILE: lib/src/templates.dart

// --- DI & IMPORT TEMPLATES ---

String importTemplate(String packageName, String featureName, String state) {
  final stateDir = _getStateDirName(state);
  final imports = [
    "import 'package:$packageName/features/$featureName/data/datasources/${featureName}_remote_data_source.dart';",
    "import 'package:$packageName/features/$featureName/data/repositories/${featureName}_repository_impl.dart';",
    "import 'package:$packageName/features/$featureName/domain/repositories/${featureName}_repository.dart';",
    "import 'package:$packageName/features/$featureName/domain/usecases/get_$featureName.dart';",
  ];

  switch (state) {
    case 'bloc':
      imports.add("import 'package:$packageName/features/$featureName/presentation/$stateDir/${featureName}_bloc.dart';");
      break;
    case 'getx':
      imports.add("import 'package:$packageName/features/$featureName/presentation/$stateDir/${featureName}_controller.dart';");
      break;
    case 'provider':
      imports.add("import 'package:$packageName/features/$featureName/presentation/$stateDir/${featureName}_provider.dart';");
      break;
  }
  return imports.join('\n');
}

// --- HELPER FUNCTION ---
String _getStateDirName(String state) {
  switch (state) {
    case 'getx': return 'controllers';
    case 'bloc': return 'bloc';
    default: return 'providers';
  }
}