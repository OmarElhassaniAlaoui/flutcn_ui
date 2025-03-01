// Implementation of the actual command
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/constants/qestions.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/init_usecase.dart';
import 'package:prompts/prompts.dart' as prompts;
import '../injection_container.dart' as di;

class InitCommand extends Command {
  @override
  final name = 'init';

  @override
  final description = 'Initialize Flutcn UI in your project';

  InitCommand();

  @override
  Future<void> run() async {
    if (Directory('flutcn.config.json').existsSync()) {
      print('Flutcn UI is already initialized');
      return;
    }

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

    // final stateManagement = prompts.choose(
    //   Questions.initCommandListQuestions['state_management']!['question']!,
    //   Questions.initCommandListQuestions['state_management']!['options']!,
    // );

    final initUseCase = di.sl<InitUseCase>();

    final result = await initUseCase(
      config: InitConfigEntity(
        themePath: themePath,
        widgetsPath: widgetsPath,
        style: style,
        baseColor: baseColor,
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
