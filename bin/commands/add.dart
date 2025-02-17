// Implementation of the add command
import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';


class AddCommand extends Command {
  @override
  String get description => "add new widgets";

  @override
  String get name => "add";

  AddCommand() {
    argParser;
  }
  @override
  Future<void> run() async {
    // Get the widget name from remaining arguments
    final widgetName =
        argResults?.rest.isEmpty == false ? argResults?.rest.first : null;

    if (widgetName == null) {
      print('Please specify a widget name: flatcn_ui add <widget-name>');
      return;
    }

    if (!File('flatcn.config.json').existsSync()) {
      print('Flutcn UI is not initialized. Please run "flatcn_ui init"');
      return;
    }

    try {
      final File configFile = File('flatcn.config.json');
      final config = await configFile.readAsString();
      final Map<String, dynamic> configJson = jsonDecode(config);
      final widgetsPath = configJson['widgetsPath'];

      print('Adding new $widgetName widget...');

      // Uncomment and implement your widget creation logic here
      // final addUseCase = di.sl<AddUseCase>();
      // final widget = WidgetEntity(
      //   name: widgetName,
      //   type: widgetName,
      //   path: '$widgetsPath/$widgetName',
      // );
      // await addUseCase.execute(widget);

      print(
          'Successfully added $widgetName widget to $widgetsPath/$widgetName');
    } catch (e) {
      print('Error adding widget: $e');
    }
  }
}
