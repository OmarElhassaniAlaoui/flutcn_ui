import 'dart:io';
import 'package:flatcn_ui/src/core/constants/app_constants.dart';
import 'package:flatcn_ui/src/data/models/init_config_model.dart';

import '../interfaces/command.dart';
import '../../core/errors/exceptions.dart';

class CommandInterfaceImpl implements CommandInterface {
  @override
  Future<void> init({
    InitConfigModel? config,
  }) async {
    try {
      try {
        // Create necessary directories
        await _createDirectory('lib/components');
        await _createDirectory('lib/themes');

        // Create initial configuration file
        await _createConfigFile();

        // Create initial theme file
        await _createDefaultTheme();

        print('✓ Successfully initialized FlatCN UI');
      } catch (e) {
        throw InitializationException();
      }
    } catch (e) {}
  }

  Future<void> _createDirectory(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
  }

  Future<void> _createConfigFile() async {
    final file = File('flatcn.config.json');
    if (!file.existsSync()) {
      await file.writeAsString('''
{
  "style": "default",
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "src/app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
''');
    }
  }

  Future<void> _createDefaultTheme() async {
    final file = File('lib/themes/default_theme.dart');
    if (!file.existsSync()) {
      await file.writeAsString(AppConstants.zincThemeFileContent);
    }
  }

  Future<void> _setupStateManagement(InitConfigModel config) async {
    final pubspecFile = File('pubspec.yaml');
    if (pubspecFile.existsSync()) {
      var content = await pubspecFile.readAsString();
      final dependencies = <String>[];

      switch (config.stateManagement.toLowerCase()) {
        case 'bloc':
          dependencies.add('  flutter_bloc: ^8.1.3');
          dependencies.add('  bloc: ^8.1.2');
          break;
        case 'provider':
          dependencies.add('  provider: ^6.0.5');
          break;
        case 'riverpod':
          dependencies.add('  flutter_riverpod: ^2.4.0');
          break;
      }

      if (dependencies.isNotEmpty) {
        if (!content.contains('dependencies:')) {
          content += '\ndependencies:\n';
        }
        for (final dep in dependencies) {
          if (!content.contains(dep)) {
            content = content.replaceFirst(
              RegExp(r'dependencies:.*?\n'),
              'dependencies:\n$dep\n',
            );
          }
        }
        await pubspecFile.writeAsString(content);

        print('\n✓ Added ${config.stateManagement} dependencies to pubspec.yaml');
        print('Run "flutter pub get" to install the dependencies');
      }
    }
  }
}
