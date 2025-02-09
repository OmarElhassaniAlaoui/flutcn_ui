import 'dart:io';
import 'package:flatcn_ui/src/core/constants/file_paths.dart';
import 'package:flatcn_ui/src/data/models/init_config_model.dart';
import '../interfaces/command.dart';
import '../../core/errors/exceptions.dart';

class CommandInterfaceImpl implements CommandInterface {
 
  @override
  Future<void> init({
    required InitConfigModel config,
  }) async {
    try {
      print('🚀 Initializing FlatCN UI...');
      // Create necessary directories
      await _createDirectory(
        config.themePath ?? 'lib/themes',
      );
      await _createDirectory(
        config.widgetsPath ?? 'lib/widgets',
      );

      // Create initial configuration file
      await _createConfigFile(
        config.widgetsPath,
        config.themePath,
        config.style,
        config.baseColor,
        config.stateManagement,
      );

      print('✅ Created initial configuration file');
      print("✅ Created widgets directory at ${config.widgetsPath}");
      print("✅ Created themes directory at ${config.themePath}");
      print("✅ Created style : ${config.baseColor}");

      switch (config.baseColor.toLowerCase()) {
        case 'zinc':
          print('✅ Creating zinc theme file');
          print(FilePaths.zincThemeFileContent);
          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.zincThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        case 'slate':
          print('✅ Creating slate theme file');

          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.slateThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        case 'gray':
          print('✅ Creating gray theme file');
          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.grayThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        default:
          await _createDefaultTheme();
      }

      print('✅ Successfully initialized FlatCN UI');
    } catch (e) {
      throw InitializationException();
    }
  }

  Future<void> _createDirectory(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
  }

  Future<void> _createConfigFile(
    String? widgetsPaht,
    String? themePath,
    String? style,
    String? baseColor,
    String? stateManagement,
  ) async {
    final file = File('flatcn.config.json');
    if (!file.existsSync()) {
      await file.writeAsString('''
{
  "widgetsPath": "$widgetsPaht",
  "themePath": "$themePath",
  "style": "${style ?? 'default'}",
  "baseColor": "${baseColor ?? 'slate'}",
  "stateManagement": "${stateManagement ?? 'bloc'}"
}
''');
    }
  }

  Future<void> _createDefaultTheme() async {
    final file = File('lib/themes/default_theme.dart');
    if (!file.existsSync()) {
      await file.create(recursive: true);
      await file.writeAsString(FilePaths.defaultThemePath);
    }
  }

  Future<void> _createTheme({
    String? themePath,
    required String paletteColors,
    required String appTheme,
  }) async {
    print('🎨 Creating theme file...');
    final appThemeFile = File('${themePath ?? 'lib/themes'}/app_theme.dart');
    final appPalleteFile =
        File('${themePath ?? 'lib/themes'}/app_pallete.dart');
    if (!appThemeFile.existsSync()) {
      await appThemeFile.create(recursive: true);
      await appPalleteFile.create(recursive: true);
      await appThemeFile.writeAsString(appTheme);
      await appPalleteFile.writeAsString(paletteColors);
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

        print(
            '\n✓ Added ${config.stateManagement} dependencies to pubspec.yaml');
        print('Run "flutter pub get" to install the dependencies');
      }
    }
  }
 
}
