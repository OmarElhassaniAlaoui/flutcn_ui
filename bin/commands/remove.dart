import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/utils/checkbox_chooser.dart';
import 'package:flutcn_ui/src/core/utils/config_reader.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/remove_usecase.dart';
import 'package:prompts/prompts.dart' as prompts;
import '../injection_container.dart' as di;

class RemoveCommand extends Command {
  @override
  String get description => "Remove widgets from your project";

  @override
  String get name => "remove";

  final SpinnerHelper _spinnerHelper = SpinnerHelper();

  RemoveCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help: 'Skip confirmation prompt',
    );
  }

  @override
  Future<void> run() async {
    try {
      if (!ConfigReader.configExists()) {
        print(
            '\x1B[37mFlutcn UI is not initialized. Please run "flutcn_ui init"\x1B[0m');
        return;
      }

      final config = await ConfigReader.readConfig();
      final widgetsPath = config.widgetsPath;
      final force = argResults?['force'] as bool? ?? false;
      final widgetName = argResults?.rest.firstOrNull;

      if (widgetName != null) {
        await _handleSingleRemoval(widgetName, widgetsPath, force);
      } else {
        await _handleInteractiveRemoval(widgetsPath, force);
      }
    } on InvalidConfigFileException catch (e) {
      print('\n❌ ${e.message}');
    } catch (e, stackTrace) {
      print('\n❌ Error in RemoveCommand:');
      print(e);
      print(stackTrace);
    }
  }

  Future<void> _handleSingleRemoval(
    String widgetName,
    String widgetsPath,
    bool force,
  ) async {
    final file = File('$widgetsPath/$widgetName.dart');
    if (!file.existsSync()) {
      print(
          '\x1B[33m⚠ Widget "$widgetName" not found at $widgetsPath/$widgetName.dart\x1B[0m');
      return;
    }

    if (!force) {
      final confirm = prompts.getBool(
        'Are you sure you want to remove $widgetName.dart?',
      );
      if (confirm != true) {
        print('\x1B[37mAborted.\x1B[0m');
        return;
      }
    }

    final removeUseCase = di.sl<RemoveUseCase>();

    await _spinnerHelper.runWithSpinner(
      message: 'Removing $widgetName widget',
      action: () async {
        final result = await removeUseCase(
          widget: WidgetEntity(name: widgetName),
          widgetsPath: widgetsPath,
        );
        result.fold(
          (failure) => throw Exception(failure.message),
          (_) {},
        );
      },
      onError: 'Error removing widget',
      onSuccess: 'Removed $widgetName widget',
    );

    print('\n\x1B[32m✔ Successfully removed: $widgetName.dart\x1B[0m');
    print('Removed from: \x1B[36m$widgetsPath/\x1B[0m');
  }

  Future<void> _handleInteractiveRemoval(
    String widgetsPath,
    bool force,
  ) async {
    final widgetDir = Directory(widgetsPath);
    if (!widgetDir.existsSync()) {
      print('\x1B[33m⚠ Widgets directory not found at $widgetsPath\x1B[0m');
      return;
    }

    final installedWidgets = widgetDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .map((f) => f.uri.pathSegments.last.replaceAll('.dart', ''))
        .toList();

    if (installedWidgets.isEmpty) {
      print('\x1B[37mNo widgets installed in $widgetsPath\x1B[0m');
      return;
    }

    print('\nInstalled Widgets (use space to select):');
    final chosenNames = MultiCheckboxListChooser(
      options: installedWidgets,
    ).choose();

    if (chosenNames.isEmpty) return;

    if (!force) {
      print('\nWidgets to remove:');
      for (final name in chosenNames) {
        print('  • $name.dart');
      }
      final confirm = prompts.getBool(
        'Are you sure you want to remove ${chosenNames.length} widget(s)?',
      );
      if (confirm != true) {
        print('\x1B[37mAborted.\x1B[0m');
        return;
      }
    }

    final removeUseCase = di.sl<RemoveUseCase>();
    List<String> successes = [];
    List<String> failures = [];

    await _spinnerHelper.runWithSpinner(
      message: 'Removing ${chosenNames.length} widget(s)',
      action: () async {
        for (final widgetName in chosenNames) {
          try {
            final result = await removeUseCase(
              widget: WidgetEntity(name: widgetName),
              widgetsPath: widgetsPath,
            );
            result.fold(
              (failure) => throw Exception(failure.message),
              (_) => successes.add(widgetName),
            );
          } catch (e) {
            failures.add(widgetName);
          }
        }
      },
    );

    _printResults(successes, failures, widgetsPath);
  }

  void _printResults(
      List<String> successes, List<String> failures, String widgetsPath) {
    final successMessage = successes.isNotEmpty
        ? '\n\x1B[32m✔ Successfully removed:'
            '\n${successes.map((n) => '  • $n.dart').join('\n')}\x1B[0m'
        : '';

    final errorMessage = failures.isNotEmpty
        ? '\n\x1B[31m✖ Failed to remove:'
            '\n${failures.map((n) => '  • $n').join('\n')}\x1B[0m'
        : '';

    print([successMessage, errorMessage].join());

    if (successes.isNotEmpty) {
      print('\nRemoved from: \x1B[36m$widgetsPath/\x1B[0m');
    }
  }
}
