import 'dart:developer';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:flatcn_ui/src/core/constants/qestions.dart';
import 'package:flatcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flatcn_ui/src/domain/usecases/init_usecase.dart';
import 'injection_container.dart' as di;

Future<void> main(List<String> arguments) async {
  await di.init();

  final runner = CommandRunner('flatcn_ui', 'A Flutter UI widgets library')
    ..addCommand(InitCommand());

  await runner.run(arguments);
}

// Implementation of the actual command
class InitCommand extends Command {
  @override
  final name = 'init';

  @override
  final description = 'Initialize FlatCN UI in your project';

  InitCommand();

  @override
  Future<void> run() async {

    if (Directory('flatcn.config.json').existsSync()) {
      print('Flatcn UI is already initialized');
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
      (_) => null, // Success message is handled in the interface implementation
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
    print("add command");
  }
}
