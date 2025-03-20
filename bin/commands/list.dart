import 'package:args/command_runner.dart';

class ListCommand extends Command {
  @override
  // TODO: implement description
  String get description => "List all available widgets";

  @override
  // TODO: implement name
  String get name => "list";

  @override
  Future<void> run() async {
    // TODO: implement run
    print("ListCommand");
  }

}