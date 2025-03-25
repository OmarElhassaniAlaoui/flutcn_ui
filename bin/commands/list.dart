import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/constants/api_constants.dart';
import 'package:flutcn_ui/src/core/helpers/check_mode.dart';
import 'package:flutcn_ui/src/core/utils/checko_box_chooser.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/add_usecase.dart';
import 'package:flutcn_ui/src/domain/usecases/list_usecase.dart';
import 'package:prompts/prompts.dart' as prompts;
import '../injection_container.dart' as di;

class ListCommand extends Command {
  @override
  String get description => "List available widgets";

  @override
  String get name => "list";

  final SpinnerHelper _spinnerHelper = SpinnerHelper();

  @override
  Future<void> run() async {
    final listUseCase = di.sl<ListUseCase>();
    final addUseCase = di.sl<AddUseCase>();
    List<WidgetEntity> allWidgets = [];
    Set<WidgetEntity> selectedWidgets = {};
    List<String> successfulDownloads = [];
    List<String> failedDownloads = [];
    List<String> skippedDownloads = [];

    try {
      if (!File('flutcn.config.json').existsSync()) {
        print('Flutcn UI is not initialized. Please run "flutcn_ui init"');
        return;
      }

      final configFile = File('flutcn.config.json');
      final config = await configFile.readAsString();
      final configJson = jsonDecode(config) as Map<String, dynamic>;
      final widgetsPath = configJson['widgetsPath'] as String;

      await _spinnerHelper.runWithSpinner(
        message: 'Fetching widgets',
        action: () async => allWidgets = await listUseCase.call(),
        onSuccess: "Fetched available widgets",
        onError: 'Error fetching widgets',
      );

      if (allWidgets.isEmpty) {
        print('No widgets available in the registry');
        return;
      }

      print("\nAvailable Widgets (use space to select):");
      final chosenNames = MultiCheckboxListChooser(
        options: allWidgets.map((e) => e.name!).toList(),
      ).choose();

      selectedWidgets = allWidgets
          .where((element) => chosenNames.contains(element.name))
          .toSet();

      if (selectedWidgets.isEmpty) {
        print('No widgets selected');
        return;
      }

      final widgetDir = Directory(widgetsPath);
      if (!widgetDir.existsSync()) await widgetDir.create(recursive: true);

      await _spinnerHelper.runWithSpinner(
        message: 'Processing ${selectedWidgets.length} widget(s)',
        action: () async {
          for (final widget in selectedWidgets) {
            final widgetName = widget.name!;
            final filePath = '$widgetsPath/$widgetName.dart';

            try {
              final actionChoice =
                  await _handleExistingFile(widgetName, widgetsPath);
              if (actionChoice == 'cancel') exit(0);
              if (actionChoice != 'overwrite') {
                if (actionChoice == 'skip') skippedDownloads.add(widgetName);
                continue;
              }

              final result = await addUseCase(
                widget: WidgetEntity(
                  name: widgetName,
                  link: isDevMode()
                      ? "${ApiConstants.widgetsDev}/${widget.link}"
                      : "${ApiConstants.widgetsProd}/${widget.link}",
                  content: "",
                ),
              );

              await result.fold(
                (failure) async => failedDownloads.add(widgetName),
                (widgetWithContent) async {
                  await File(filePath)
                      .writeAsString(widgetWithContent.content!);
                  successfulDownloads.add(widgetName);
                },
              );
            } catch (e) {
              failedDownloads.add(widgetName);
            }
          }
        },
      );

      _printResults(
          successfulDownloads, skippedDownloads, failedDownloads, widgetsPath);
    } catch (e, stackTrace) {
      print('\n❌ Unexpected error:');
      print(e);
      print(stackTrace);
    }
  }

  Future<String> _handleExistingFile(
      String widgetName, String widgetsPath) async {
    final file = File('$widgetsPath/$widgetName.dart');
    if (!file.existsSync()) return 'overwrite';
    final response = prompts.choose(
      "\n Widget '$widgetName' already exists. What would you like to do?",
      [
        'overwrite',
        'skip',
        'cancel',
      ],
    );
    return response ?? 'cancel';
  }

  void _printResults(
    List<String> successes,
    List<String> skipped,
    List<String> failures,
    String widgetsPath,
  ) {
    final successMessage = successes.isNotEmpty
        ? '\n\x1B[32m✔ Successfully created:'
            '\n${successes.map((n) => '  • $n.dart').join('\n')}\x1B[0m'
        : '';

    final skipMessage = skipped.isNotEmpty
        ? '\n\x1B[33m⚠ Skipped:'
            '\n${skipped.map((n) => '  • $n.dart').join('\n')}\x1B[0m'
        : '';

    final errorMessage = failures.isNotEmpty
        ? '\n\x1B[31m✖ Failed to create:'
            '\n${failures.map((n) => '  • $n').join('\n')}\x1B[0m'
        : '';

    print([successMessage, skipMessage, errorMessage].join());

    if (successes.isNotEmpty) {
      print('\nFiles created in: \x1B[36m$widgetsPath/\x1B[0m');
    }
  }
}
