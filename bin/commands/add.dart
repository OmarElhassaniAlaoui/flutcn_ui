import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/add_usecase.dart';
import '../injection_container.dart' as di;

class AddCommand extends Command {
  @override
  String get description => "Add new widgets";

  @override
  String get name => "add";

  final SpinnerHelper _spinnerHelper = SpinnerHelper();

  AddCommand() {
    argParser;
  }

  @override
  Future<void> run() async {
    try {
      
      final widgetName =
          argResults?.rest.isEmpty == false ? argResults?.rest.first : null;

      if (widgetName == null) {
        print('Please specify a widget name: flutcn_ui add <widget-name>');
        return;
      }

      if (!File('flutcn.config.json').existsSync()) {
        print('Flutcn UI is not initialized. Please run "flutcn_ui init"');
        return;
      }

      final File configFile = File('flutcn.config.json');
      final config = await configFile.readAsString();
      final Map<String, dynamic> configJson = jsonDecode(config);
      final widgetsPath = configJson['widgetsPath'];
      final style = configJson['style'];

      final addUseCase = di.sl<AddUseCase>();
      late WidgetEntity resultWidget;

      // Fetch widget template with spinner
      await _spinnerHelper.runWithSpinner(
        message: 'Installing $widgetName widget',
        action: () async {
          final result = await addUseCase(
            widget: WidgetEntity(
              name: widgetName,
              link:
                  "https://flutcnui.netlify.app/registry/widgets/$style/$widgetName",
              content: '',
            ),
          );

          resultWidget = result.fold(
            (failure) => throw Exception(failure.message),
            (widget) => widget,
          );
        },
      );

      // Create widget files with spinner
      await _spinnerHelper.runWithSpinner(
        message: "Creating widget file.",
        action: () async {
          final widgetDir = Directory('$widgetsPath');
          if (!widgetDir.existsSync()) {
            await widgetDir.create(recursive: true);
          }
          final widgetFilePath = '$widgetsPath/$widgetName.dart';
          await File(widgetFilePath).writeAsString(resultWidget.content);
        },
      );

      print(
          '\n✨ Successfully created $widgetName widget in $widgetsPath/$widgetName.dart');
    } catch (e, stackTrace) {
      print('\n❌ Error in AddCommand:');
      print(e);
      print(stackTrace);
    }
  }
}
