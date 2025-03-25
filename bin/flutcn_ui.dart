import 'package:args/command_runner.dart';
import 'injection_container.dart' as di;
import 'commands/init.dart';
import 'commands/add.dart';
import 'commands/list.dart';

Future<void> main(List<String> arguments) async {
  await di.init();

  final runner = CommandRunner('flutcn_ui', 'Flutter UI Component Generator')
    ..addCommand(InitCommand())
    ..addCommand(AddCommand())
    ..addCommand(ListCommand());

  await runner.run(arguments);
}
