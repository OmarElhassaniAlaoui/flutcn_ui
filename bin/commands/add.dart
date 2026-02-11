import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/utils/checkbox_chooser.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/add_usecase.dart';
import 'package:flutcn_ui/src/domain/usecases/list_usecase.dart';
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
      if (!File('flutcn.config.json').existsSync()) {
        print(
            '\x1B[37mFlutcn UI is not initialized. Please run "flutcn_ui init"\x1B[0m');

        return;
      }

      final config = await _getConfig();
      final widgetsPath = config['widgetsPath'] as String;
      final widgetName = argResults?.rest.firstOrNull;

      if (widgetName != null) {
        await _handleSingleWidget(widgetName, widgetsPath, config);
      } else {
        await _handleMultiWidgetSelection(widgetsPath, config);
      }
    } catch (e, stackTrace) {
      print('\n❌ Error in AddCommand:');
      print(e);
      print(stackTrace);
    }
  }

  Future<void> _handleSingleWidget(
    String widgetName,
    String widgetsPath,
    Map<String, dynamic> config,
  ) async {
    final addUseCase = di.sl<AddUseCase>();
    late WidgetEntity resultWidget;

    await _spinnerHelper.runWithSpinner(
      message: 'Installing $widgetName widget',
      action: () async {
        final result = await addUseCase(
          widget: WidgetEntity(
            name: widgetName,
            link: _buildWidgetUrl(widgetName, configJson: config),
            content: '',
          ),
        );
        resultWidget = result.fold(
          (failure) => throw Exception(failure.message),
          (widget) => widget,
        );
      },
      onError: "Error adding widget",
      onSuccess: "Successfully added $widgetName widget",
    );

    await _createWidgetFile(widgetsPath, widgetName, resultWidget.content!);
    print('\n\x1B[32m✔ Successfully created: $widgetName.dart\x1B[0m');
    print('File created in: \x1B[36m$widgetsPath/\x1B[0m');
  }

  Future<void> _handleMultiWidgetSelection(
    String widgetsPath,
    Map<String, dynamic> config,
  ) async {
    final listUseCase = di.sl<ListUseCase>();
    final addUseCase = di.sl<AddUseCase>();
    List<WidgetEntity> allWidgets = [];
    List<String> successes = [];
    List<String> failures = [];

    await _spinnerHelper.runWithSpinner(
      message: 'Fetching available widgets',
      action: () async => allWidgets = await listUseCase.call(),
      onSuccess: "Fetched available widgets",
      onError: 'Error fetching widgets',
    );

    if (allWidgets.isEmpty) return;

    print("\nAvailable Widgets (use space to select):");
    final chosenNames = MultiCheckboxListChooser(
      options: allWidgets.map((e) => e.name!).toList(),
    ).choose();

    if (chosenNames.isEmpty) return;

    await _spinnerHelper.runWithSpinner(
      message: 'Downloading ${chosenNames.length} widget(s)',
      action: () async {
        for (final widgetName in chosenNames) {
          try {
            final result = await addUseCase(
              widget: WidgetEntity(
                name: widgetName,
                link: _buildWidgetUrl(widgetName, configJson: config),
                content: '',
              ),
            );

            await result.fold(
              (failure) => throw Exception(failure.message),
              (widget) async {
                await _writeFile(widgetsPath, widgetName, widget.content!);
                successes.add(widgetName);
              },
            );
          } catch (e) {
            failures.add(widgetName);
          }
        }
      },
    );

    _printResults(successes, failures, widgetsPath);
  }

  String _buildWidgetUrl(String widgetName,
      {required Map<String, dynamic> configJson}) {
    final style = configJson['style'] as String;
    return "/widgets/$style/$widgetName";
  }

  Future<Map<String, dynamic>> _getConfig() async {
    return jsonDecode(await File('flutcn.config.json').readAsString());
  }

  Future<void> _createWidgetFile(
    String widgetsPath,
    String widgetName,
    String content,
  ) async {
    await _spinnerHelper.runWithSpinner(
      message: "Creating $widgetName.dart",
      action: () async => _writeFile(widgetsPath, widgetName, content),
      onError: "Error creating file",
      onSuccess: "Created $widgetName.dart",
    );
  }

  Future<void> _writeFile(
      String widgetsPath, String widgetName, String content) async {
    final widgetDir = Directory(widgetsPath);
    if (!widgetDir.existsSync()) await widgetDir.create(recursive: true);
    await File('$widgetsPath/$widgetName.dart').writeAsString(content);
  }

  void _printResults(
      List<String> successes, List<String> failures, String widgetsPath) {
    final successMessage = successes.isNotEmpty
        ? '\n\x1B[32m✔ Successfully created:'
            '\n${successes.map((n) => '  • $n.dart').join('\n')}\x1B[0m'
        : '';

    final errorMessage = failures.isNotEmpty
        ? '\n\x1B[31m✖ Failed to create:'
            '\n${failures.map((n) => '  • $n').join('\n')}\x1B[0m'
        : '';

    print([successMessage, errorMessage].join());

    if (successes.isNotEmpty) {
      print('\nFiles created in: \x1B[36m$widgetsPath/\x1B[0m');
    }
  }
}
