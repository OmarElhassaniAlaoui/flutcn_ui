import 'dart:convert';
import 'dart:io';
import 'package:flutcn_ui/src/core/services/api_service.dart';
import 'package:flutcn_ui/src/data/models/init_config_model.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';
import '../interfaces/command.dart';
import '../../core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';

class CommandInterfaceImpl implements CommandInterface {
  final ApiService apiService;

  CommandInterfaceImpl({required this.apiService});
  final SpinnerHelper _spinnerHelper = SpinnerHelper();
  @override
  Future<void> init({
    required InitConfigModel config,
  }) async {
    // Create necessary directories
    await _createDirectory(config.themePath);
    await _createDirectory(config.widgetsPath);

    // Fetch theme files from registry (can throw OfflineException,
    // ThemeNotFoundException, etc. — these propagate to the repository)
    await _fetchAndCreateTheme(
      themePath: config.themePath,
      style: config.style,
      baseColor: config.baseColor.toLowerCase(),
    );

    if (config.installGoogleFonts) {
      await _addGoogleFontsDependency();
    }

    // Config file created LAST — only written if all operations above succeeded.
    // This prevents a broken half-initialized state where config exists
    // but theme files are missing.
    await _createConfigFile(config);
  }

  Future<void> _createDirectory(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
  }

  Future<void> _createConfigFile(InitConfigModel config) async {
    final file = File('flutcn.config.json');
    if (!file.existsSync()) {
      final encoder = const JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(config.toJson()));
    }
  }

  Future<void> _fetchAndCreateTheme({
    required String themePath,
    required String style,
    required String baseColor,
  }) async {
    // Use spinner to indicate theme fetching
    await _spinnerHelper.runWithSpinner(
      message: 'Fetching theme files',
      onSuccess: "Fetched theme files",
      onError: "Error fetching theme files",
      action: () async {
        // Fetch palette colors from API
        final paletteResponse = await apiService.get(
          '/colorScheme/$style/$baseColor',
          headers: {'Content-Type': 'text/plain'},
        );

        // Fetch theme definition from API
        final themeResponse = await apiService.get(
          '/theme/$style',
          headers: {'Content-Type': 'text/plain'},
        );

        if (paletteResponse.status != 200) {
          throw ThemeNotFoundException(
            message:
                'Color scheme not found for style "$style" and color "$baseColor" (HTTP ${paletteResponse.status})',
          );
        }

        if (themeResponse.status != 200) {
          throw ThemeNotFoundException(
            message:
                'Theme not found for style "$style" (HTTP ${themeResponse.status})',
          );
        }

        final appThemeFile = File('$themePath/app_theme.dart');
        final appPaletteFile = File('$themePath/app_palette.dart');

        if (!appThemeFile.existsSync()) {
          await appThemeFile.create(recursive: true);
          await appPaletteFile.create(recursive: true);
          await appThemeFile.writeAsString(themeResponse.body.toString());
          await appPaletteFile.writeAsString(paletteResponse.body.toString());
        }
      },
    );
  }

  // Future<void> _createDefaultTheme() async {
  //   final file = File('lib/themes/default_theme.dart');
  //   if (!file.existsSync()) {
  //     await file.create(recursive: true);
  //     await file.writeAsString(FilePaths.defaultThemePath);
  //   }
  // }

  Future<void> _addGoogleFontsDependency() async {
    await _spinnerHelper.runWithSpinner(
      message: 'Installing google_fonts dependency',
      onSuccess: "Added google_fonts to pubspec.yaml",
      onError: "Error adding google_fonts dependency",
      action: () async {
        final pubspecFile = File('pubspec.yaml');
        if (!pubspecFile.existsSync()) {
          throw InitializationException('pubspec.yaml not found');
        }

        String content = await pubspecFile.readAsString();
        const dependency = '  google_fonts: ^6.0.0';

        if (!content.contains('google_fonts:')) {
          if (content.contains('dependencies:')) {
            content = content.replaceFirst(
              RegExp(r'dependencies:\s*\n'),
              'dependencies:\n$dependency\n',
            );
          } else {
            content += '\ndependencies:\n$dependency\n';
          }
          await pubspecFile.writeAsString(content);
        }
      },
    );
  }

  // Future<void> _createTheme({
  //   String? themePath,
  //   required String paletteColors,
  //   required String appTheme,
  // }) async {
  //   final appThemeFile = File('${themePath ?? 'lib/themes'}/app_theme.dart');
  //   final appPalleteFile =
  //       File('${themePath ?? 'lib/themes'}/app_palette.dart');
  //   if (!appThemeFile.existsSync()) {
  //     await appThemeFile.create(recursive: true);
  //     await appPalleteFile.create(recursive: true);
  //     await appThemeFile.writeAsString(appTheme);
  //     await appPalleteFile.writeAsString(paletteColors);
  //   }
  // }

  // NOTE: we don't need this for now

  // Future<void> _setupStateManagement(InitConfigModel config) async {
  //   final pubspecFile = File('pubspec.yaml');
  //   if (pubspecFile.existsSync()) {
  //     var content = await pubspecFile.readAsString();
  //     final dependencies = <String>[];

  //     switch (config.stateManagement.toLowerCase()) {
  //       case 'bloc':
  //         dependencies.add('  flutter_bloc: ^8.1.3');
  //         dependencies.add('  bloc: ^8.1.2');
  //         break;
  //       case 'provider':
  //         dependencies.add('  provider: ^6.0.5');
  //         break;
  //       case 'riverpod':
  //         dependencies.add('  flutter_riverpod: ^2.4.0');
  //         break;
  //     }

  //     if (dependencies.isNotEmpty) {
  //       if (!content.contains('dependencies:')) {
  //         content += '\ndependencies:\n';
  //       }
  //       for (final dep in dependencies) {
  //         if (!content.contains(dep)) {
  //           content = content.replaceFirst(
  //             RegExp(r'dependencies:.*?\n'),
  //             'dependencies:\n$dep\n',
  //           );
  //         }
  //       }
  //       await pubspecFile.writeAsString(content);

  //       print(
  //           '\n✓ Added ${config.stateManagement} dependencies to pubspec.yaml');
  //       print('Run "flutter pub get" to install the dependencies');
  //     }
  //   }
  // }

  @override
  Future<WidgetModel> add({required WidgetModel widget}) async {
    final response = await apiService.get(
      widget.link!,
      headers: {
        'Content-Type': 'text/plain',
      },
    );

    if (response.status != 200) {
      throw ComponentNotFoundException(
        message: 'Widget "${widget.name}" not found (HTTP ${response.status})',
      );
    }

    return WidgetModel(
      name: widget.name,
      link: widget.link,
      content: response.body.toString(),
    );
  }

  @override
  Future<List<WidgetModel>> list() async {
    final response = await apiService.get('/widgets',
        headers: {'Content-Type': 'application/json'});

    if (response.status != 200) {
      throw ServerException(
        message: 'Failed to fetch widgets (HTTP ${response.status})',
      );
    }

    final Map<String, dynamic> data = response.body;

    if (!data.containsKey('widgets')) {
      throw ServerException(
        message:
            'Unexpected API response: missing "widgets" key',
      );
    }

    final List<dynamic> widgetsJson = data['widgets'] ?? [];

    return widgetsJson
        .map((widgetJson) => WidgetModel.fromJSON(widgetJson))
        .toList();
  }
}
