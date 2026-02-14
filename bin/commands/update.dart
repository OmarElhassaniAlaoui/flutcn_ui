import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/utils/checkbox_chooser.dart';
import 'package:flutcn_ui/src/core/utils/config_reader.dart';
import 'package:flutcn_ui/src/core/utils/lockfile_manager.dart';
import 'package:flutcn_ui/src/core/utils/spinners.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/update_usecase.dart';
import '../injection_container.dart' as di;

class UpdateCommand extends Command {
  @override
  String get description => "Update installed widgets to the latest version";

  @override
  String get name => "update";

  final SpinnerHelper _spinnerHelper = SpinnerHelper();

  UpdateCommand() {
    argParser.addFlag(
      'all',
      abbr: 'a',
      negatable: false,
      help: 'Update all installed widgets',
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
      final updateAll = argResults?['all'] as bool? ?? false;
      final widgetName = argResults?.rest.firstOrNull;

      if (widgetName != null) {
        await _handleSingleUpdate(widgetName, widgetsPath, config);
      } else if (updateAll) {
        await _handleUpdateAll(widgetsPath, config);
      } else {
        await _handleInteractiveUpdate(widgetsPath, config);
      }
    } on InvalidConfigFileException catch (e) {
      print('\n❌ ${e.message}');
    } catch (e, stackTrace) {
      print('\n❌ Error in UpdateCommand:');
      print(e);
      print(stackTrace);
    }
  }

  Future<void> _handleSingleUpdate(
    String widgetName,
    String widgetsPath,
    InitConfigEntity config,
  ) async {
    final file = File('$widgetsPath/$widgetName.dart');
    if (!file.existsSync()) {
      print(
          '\x1B[33m⚠ Widget "$widgetName" is not installed at $widgetsPath/$widgetName.dart\x1B[0m');
      return;
    }

    final updateUseCase = di.sl<UpdateUseCase>();
    late String status;

    await _spinnerHelper.runWithSpinner(
      message: 'Updating $widgetName widget',
      action: () async {
        final result = await updateUseCase(
          widget: WidgetEntity(
            name: widgetName,
            link: _buildWidgetUrl(widgetName, config: config),
          ),
          widgetsPath: widgetsPath,
        );
        result.fold(
          (failure) => throw Exception(failure.message),
          (updatedWidget) {
            status = _detectChangeStatus(widgetName, updatedWidget.content!);
            LockfileManager.recordWidget(
                widgetName, config.style, updatedWidget.content!);
          },
        );
      },
      onError: 'Error updating widget',
      onSuccess: 'Checked $widgetName widget',
    );

    _printSingleStatus(widgetName, status, widgetsPath);
  }

  Future<void> _handleUpdateAll(
    String widgetsPath,
    InitConfigEntity config,
  ) async {
    final widgetNames = _getInstalledWidgets(widgetsPath);
    if (widgetNames == null) return;

    await _updateWidgets(widgetNames, widgetsPath, config);
  }

  Future<void> _handleInteractiveUpdate(
    String widgetsPath,
    InitConfigEntity config,
  ) async {
    final installedWidgets = _getInstalledWidgets(widgetsPath);
    if (installedWidgets == null) return;

    print('\nInstalled Widgets (use space to select):');
    final chosenNames = MultiCheckboxListChooser(
      options: installedWidgets,
    ).choose();

    if (chosenNames.isEmpty) return;

    await _updateWidgets(chosenNames.toList(), widgetsPath, config);
  }

  Future<void> _updateWidgets(
    List<String> widgetNames,
    String widgetsPath,
    InitConfigEntity config,
  ) async {
    final updateUseCase = di.sl<UpdateUseCase>();
    Map<String, String> statuses = {};
    List<String> failures = [];

    await _spinnerHelper.runWithSpinner(
      message: 'Updating ${widgetNames.length} widget(s)',
      action: () async {
        for (final widgetName in widgetNames) {
          try {
            final result = await updateUseCase(
              widget: WidgetEntity(
                name: widgetName,
                link: _buildWidgetUrl(widgetName, config: config),
              ),
              widgetsPath: widgetsPath,
            );
            result.fold(
              (failure) => throw Exception(failure.message),
              (updatedWidget) {
                statuses[widgetName] =
                    _detectChangeStatus(widgetName, updatedWidget.content!);
                LockfileManager.recordWidget(
                    widgetName, config.style, updatedWidget.content!);
              },
            );
          } catch (e) {
            failures.add(widgetName);
          }
        }
      },
    );

    _printBatchResults(statuses, failures, widgetsPath);
  }

  /// Compares fetched content against lockfile hash to determine change status.
  String _detectChangeStatus(String widgetName, String newContent) {
    final entry = LockfileManager.getWidget(widgetName);
    if (entry == null) return 'newly tracked';

    final oldHash = entry['contentHash'] as String?;
    final newHash = LockfileManager.computeHash(newContent);
    return oldHash == newHash ? 'up-to-date' : 'updated';
  }

  void _printSingleStatus(
      String widgetName, String status, String widgetsPath) {
    switch (status) {
      case 'up-to-date':
        print('\n\x1B[32m✔ $widgetName: already up-to-date\x1B[0m');
      case 'updated':
        print('\n\x1B[36m↑ $widgetName: updated with latest changes\x1B[0m');
      case 'newly tracked':
        print(
            '\n\x1B[33m⚡ $widgetName: updated (now tracked in lockfile)\x1B[0m');
    }
    print('Location: \x1B[36m$widgetsPath/\x1B[0m');
  }

  void _printBatchResults(
    Map<String, String> statuses,
    List<String> failures,
    String widgetsPath,
  ) {
    if (statuses.isNotEmpty) {
      print('');
      for (final entry in statuses.entries) {
        switch (entry.value) {
          case 'up-to-date':
            print('\x1B[32m  ✔ ${entry.key}: already up-to-date\x1B[0m');
          case 'updated':
            print(
                '\x1B[36m  ↑ ${entry.key}: updated with latest changes\x1B[0m');
          case 'newly tracked':
            print(
                '\x1B[33m  ⚡ ${entry.key}: updated (now tracked in lockfile)\x1B[0m');
        }
      }
    }

    if (failures.isNotEmpty) {
      print(
          '\n\x1B[31m✖ Failed to update:\n${failures.map((n) => '  • $n').join('\n')}\x1B[0m');
    }

    if (statuses.isNotEmpty) {
      print('\nUpdated in: \x1B[36m$widgetsPath/\x1B[0m');
    }
  }

  List<String>? _getInstalledWidgets(String widgetsPath) {
    final widgetDir = Directory(widgetsPath);
    if (!widgetDir.existsSync()) {
      print('\x1B[33m⚠ Widgets directory not found at $widgetsPath\x1B[0m');
      return null;
    }

    final installedWidgets = widgetDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .map((f) => f.uri.pathSegments.last.replaceAll('.dart', ''))
        .toList();

    if (installedWidgets.isEmpty) {
      print('\x1B[37mNo widgets installed in $widgetsPath\x1B[0m');
      return null;
    }

    return installedWidgets;
  }

  String _buildWidgetUrl(String widgetName,
      {required InitConfigEntity config}) {
    return "/widgets/${config.style}/$widgetName";
  }
}
