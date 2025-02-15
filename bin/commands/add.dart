// Implementation of the add command
import 'dart:io';

import 'package:args/command_runner.dart';

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
