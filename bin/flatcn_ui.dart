import 'package:args/command_runner.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:flatcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flatcn_ui/src/domain/usecases/init_usecase.dart';
import 'injection_container.dart' as di;

Future<void> main(List<String> arguments) async {
  await di.init();

  final runner = CommandRunner('flatcn_ui', 'A Flutter UI components generator')
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
    final initUseCase = di.sl<InitUseCase>();

    final dialog = CLI_Dialog(
      questions: [
        ['wich path do you choose for setup theme ?', 'theme_path'],
        ['path to your widgets', 'widgets_path'],
      ],
      listQuestions: [
        [
          {
            "question": "Which style would you like to use ?",
            "options": [
              "New York",
            ]
          },
          'style'
        ],
        [
          {
            "question": "Which color would you like to use as base color?",
            "options": [
              "Zinc",
              "Slate",
              "Gray",
            ]
          },
          'base_color'
        ],
        [
          {
            "question": "Which state managment do you want to use for widgets",
            "options": [
              "Bloc",
              "Provider",
              "Riverpod",
            ]
          },
          'state_management'
        ],
      ],
    );
    final answers = dialog.ask();
    print(answers);

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
