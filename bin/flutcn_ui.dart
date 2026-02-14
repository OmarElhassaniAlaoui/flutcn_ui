import 'package:args/command_runner.dart';
import 'injection_container.dart' as di;
import 'commands/init.dart';
import 'commands/add.dart';
import 'commands/list.dart';
import 'commands/remove.dart';
import 'commands/update.dart';

Future<void> main(List<String> arguments) async {
  await di.init();

  final runner = CommandRunner('flutcn_ui', 'Flutter UI Component Generator')
    ..addCommand(InitCommand())
    ..addCommand(AddCommand())
    ..addCommand(ListCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(UpdateCommand());

  await runner.run(arguments);
}
