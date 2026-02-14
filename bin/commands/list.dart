import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/utils/checkbox_chooser.dart';
import 'package:flutcn_ui/src/core/utils/config_reader.dart';
import 'package:flutcn_ui/src/core/utils/lockfile_manager.dart';
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
      if (!ConfigReader.configExists()) {
        print('Flutcn UI is not initialized. Please run "flutcn_ui init"');
        return;
      }

      final config = await ConfigReader.readConfig();
      final widgetsPath = config.widgetsPath;
      final style = config.style;

      await _spinnerHelper.runWithSpinner(
        message: 'Fetching widgets',
        action: () async {
          final result = await listUseCase.call();
          allWidgets = result.fold(
            (failure) => throw Exception(failure.message),
            (widgets) => widgets,
          );
        },
        onSuccess: "Fetched available widgets",
        onError: 'Error fetching widgets',
      );

      if (allWidgets.isEmpty) {
        print('No widgets available in the registry');
        return;
      }

      // Show install status for each widget
      final lockfile = LockfileManager.readLockfile();
      final widgets = lockfile['widgets'] as Map<String, dynamic>;
      final localFiles = <String>{};
      final widgetDir = Directory(widgetsPath);
      if (widgetDir.existsSync()) {
        localFiles.addAll(widgetDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .map((f) => f.uri.pathSegments.last.replaceAll('.dart', '')));
      }

      print('\nAvailable Widgets (use space to select):\n');
      for (final w in allWidgets) {
        final name = w.name!;
        final isLocal = localFiles.contains(name);
        final isTracked = widgets.containsKey(name);

        String status = '';
        if (isLocal && isTracked) {
          final localContent =
              File('$widgetsPath/$name.dart').readAsStringSync();
          status = LockfileManager.isUpToDate(name, localContent)
              ? ' \x1B[32m[installed]\x1B[0m'
              : ' \x1B[33m[modified locally]\x1B[0m';
        } else if (isLocal && !isTracked) {
          status = ' \x1B[37m[installed - untracked]\x1B[0m';
        }
        print('  $name$status');
      }
      print('');

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

              print("Downloading ${widget.name}...");

              final result = await addUseCase(
                widget: WidgetEntity(
                  name: widgetName,
                  link: "/widgets/$style/${widget.name}",
                  content: "",
                ),
              );

              await result.fold(
                (failure) async => failedDownloads.add(widgetName),
                (widgetWithContent) async {
                  await File(filePath)
                      .writeAsString(widgetWithContent.content!);
                  LockfileManager.recordWidget(
                      widgetName, style, widgetWithContent.content!);
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
    } on InvalidConfigFileException catch (e) {
      print('\n❌ ${e.message}');
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
