import 'dart:io';
import 'package:flutcn_ui/src/core/constants/file_paths.dart';
import 'package:flutcn_ui/src/core/services/api_service.dart';
import 'package:flutcn_ui/src/data/models/init_config_model.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';
import '../interfaces/command.dart';
import '../../core/errors/exceptions.dart';

class CommandInterfaceImpl implements CommandInterface {
  final ApiService apiService;

  CommandInterfaceImpl({required this.apiService});

  @override
  Future<void> init({
    required InitConfigModel config,
  }) async {
    try {
      // Create necessary directories
      await _createDirectory(
        config.themePath,
      );
      await _createDirectory(
        config.widgetsPath,
      );

      // Create initial configuration file
      await _createConfigFile(
        config.widgetsPath,
        config.themePath,
        config.style,
        config.baseColor,
        config.stateManagement,
      );

      switch (config.baseColor.toLowerCase()) {
        case 'zinc':
          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.zincThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        case 'slate':
          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.slateThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        case 'gray':
          await _createTheme(
            themePath: config.themePath,
            paletteColors: FilePaths.grayThemeFileContent,
            appTheme: FilePaths.newYorkThemeFileContent,
          );
          break;
        default:
          await _createDefaultTheme();
      }

      switch (config.stateManagement.toLowerCase()) {
        case 'bloc':
          await _setupStateManagement(config);
          break;
        case 'provider':
          await _setupStateManagement(config);
          break;
        case 'riverpod':
          await _setupStateManagement(config);
          break;
      }
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

  @override
  Future<WidgetModel> add({required WidgetModel widget}) async {
    final response = await apiService.get(
      widget.link,
      headers: {
        'Content-Type': 'text/plain',
      },
    );
    return WidgetModel(
      name: widget.name,
      link: widget.link,
      content: response.body.toString(),
    );
  }
}
