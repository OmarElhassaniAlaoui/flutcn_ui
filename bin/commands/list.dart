import 'package:args/command_runner.dart';

class ListCommand extends Command {
  @override
  String get description => "List all available widgets";

  @override
  String get name => "list";

  ListCommand();

  @override
  Future<void> run() async {
    print("available widgets");
  }

  
}
