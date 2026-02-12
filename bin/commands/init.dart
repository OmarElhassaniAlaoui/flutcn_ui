// Implementation of the actual command
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/constants/questions.dart';
import 'package:flutcn_ui/src/core/utils/config_reader.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/init_usecase.dart';
import 'package:prompts/prompts.dart' as prompts;
import '../injection_container.dart' as di;

class InitCommand extends Command {
  @override
  final name = 'init';

  @override
  final description = 'Initialize Flutcn UI in your project';

  InitCommand() {
    argParser.addFlag(
      'default',
      abbr: 'd',
      help:
          'Initialize flutcn ui with default config lib/themes and lib/widgets and default style',
    );
  }

  @override
  Future<void> run() async {
    final initUseCase = di.sl<InitUseCase>();

    if (ConfigReader.configExists()) {
      print('Flutcn UI is already initialized');
      return;
    }

    if (argResults?.wasParsed('default') == true) {
      try {
        final result = await initUseCase(
          config: InitConfigEntity(
            themePath: 'lib/themes',
            widgetsPath: 'lib/widgets',
            style: 'new-york',
            baseColor: 'Zinc',
            // stateManagement: stateManagement,
          ),
        );
        result.fold(
          (failure) => print('Error: ${failure.message}'),
          (_) => print(
              '\x1B[32m\u{2714} Flutcn UI initialized successfully!\x1B[0m'),
        );
      } catch (e) {
        print('Error: $e');
      }
      return;
    }

    // final appName = await getAppName();

    final themePath = prompts.get(Questions.initCommandQuestions['theme_path']!,
        defaultsTo: 'lib/themes');

    final widgetsPath = prompts.get(
        Questions.initCommandQuestions['widgets_path']!,
        defaultsTo: 'lib/widgets');

    final style = prompts.choose(
      Questions.initCommandListQuestions['style']!['question']!,
      Questions.initCommandListQuestions['style']!['options']!,
    );

    final baseColor = prompts.choose(
      Questions.initCommandListQuestions['base_color']!['question']!,
      Questions.initCommandListQuestions['base_color']!['options']!,
    );

    // Prompt user for google_fonts installation
    final installGoogleFonts = prompts.getBool(
      'The theme uses Google Fonts. Do you want to add the google_fonts package to your pubspec.yaml?',
      defaultsTo: true,
    );

    // TODO: Add state management question later

    // final stateManagement = prompts.choose(
    //   Questions.initCommandListQuestions['state_management']!['question']!,
    //   Questions.initCommandListQuestions['state_management']!['options']!,
    // );

    final result = await initUseCase(
      config: InitConfigEntity(
        themePath: themePath,
        widgetsPath: widgetsPath,
        style: style,
        baseColor: baseColor,
        installGoogleFonts: installGoogleFonts , 
        // stateManagement: stateManagement,
      ),
    );

    result.fold(
      (failure) => print('Error: ${failure.message}'),
      (_) =>
          print('\x1B[32m\u{2714} Flutcn UI initialized successfully!\x1B[0m'),
    );
  }
}

Future<String?> getAppName() async {
  try {
    // Read the pubspec.yaml file
    final pubspecFile = File('pubspec.yaml');
    // Check if file exists
    if (!pubspecFile.existsSync()) {
      print('pubspec.yaml file not found');
      return null;
    }

    // Read the file content
    final pubspecContent = await pubspecFile.readAsString();
    // Find the line containing 'name:'
    final nameLine =
        pubspecContent.split('\n').firstWhere((line) => line.contains('name:'));
    // Extract the name from the line
    final name = nameLine.split(':')[1].trim();
    return name;
  } catch (e) {
    print("Error reading pubspec.yaml: $e");
  }
  return null;
}
