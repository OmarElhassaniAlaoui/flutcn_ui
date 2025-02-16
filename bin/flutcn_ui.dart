import 'package:args/args.dart';
import 'injection_container.dart' as di;
import 'commands/init.dart';
import 'commands/add.dart';

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



