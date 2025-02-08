import 'package:flatcn_ui/flatcn_ui.dart' as flatcn_ui;

import 'package:args/command_runner.dart';
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
    final result = await initUseCase();
    
    result.fold(
      (failure) => print('Error: ${failure.message}'),
      (_) => null, // Success message is handled in the interface implementation
    );
  }
}