import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:flutcn_ui/src/core/constants/qestions.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/init_usecase.dart';
import 'injection_container.dart' as di;

Future<void> main(List<String> arguments) async {
  await di.init();

  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('add');

  final results = parser.parse(arguments);

  if (results.command?.name == 'init') {
    await InitCommand().run();
  } else if (results.command?.name == 'add') {
    await AddCommand().run();
  } else {
    print('No command provided. Available commands: init, add');
    print(parser.usage);
  }
}

// Implementation of the actual command
class InitCommand extends Command {
  @override
  final name = 'init';

  @override
  final description = 'Initialize Flutcn UI in your project';

  InitCommand();

  @override
  Future<void> run() async {
    if (Directory('flatcn.config.json').existsSync()) {
      print('Flutcn UI is already initialized');
      return;
    }

    final initUseCase = di.sl<InitUseCase>();
    final dialog = CLI_Dialog(
      questions: Questions.initCommandQuestions,
      listQuestions: Questions.initCommandListQuestions,
    );
    final answers = dialog.ask();
    final result = await initUseCase(
      config: InitConfigEntity(
        themePath: answers['theme_path'],
        widgetsPath: answers['widgets_path'],
        style: answers['style'],
        baseColor: answers['base_color'],
        stateManagement: answers['state_management'],
      ),
    );

    result.fold(
      (failure) => print('Error: ${failure.message}'),
      (_) =>
          print('\x1B[32m\u{2714} Flutcn UI initialized successfully!\x1B[0m'),
    );
  }
}

// Implementation of the add command
class AddCommand extends Command {
  @override
  String get description => "add new widgets";

  @override
  String get name => "add";

  AddCommand();

  @override
  Future<void> run() async {
    if (!Directory('flatcn.config.json').existsSync()) {
      print(
          'Flutcn UI is not initialized please run "dart run flutcn_ui init"');
      return;
    }
  }
}
