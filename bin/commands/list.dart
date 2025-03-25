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

    try {
      // Check for config file first
      if (!File('flutcn.config.json').existsSync()) {
        print('Flutcn UI is not initialized. Please run "flutcn_ui init"');
        return;
      }

      // Read config
      final configFile = File('flutcn.config.json');
      final config = await configFile.readAsString();
      final configJson = jsonDecode(config) as Map<String, dynamic>;
      final widgetsPath = configJson['widgetsPath'] as String;

      // Fetch widgets with spinner
      await _spinnerHelper.runWithSpinner(
        message: 'Fetching widgets',
        action: () async {
          allWidgets = await listUseCase.call();
        },
        onSuccess: "Fetched available widgets",
        onError: 'Error fetching widgets',
      );

      if (allWidgets.isEmpty) {
        print('No widgets available in the registry');
        return;
      }

      // Show widget selection
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

      // Ensure widgets directory exists
      final widgetDir = Directory(widgetsPath);
      if (!widgetDir.existsSync()) {
        await widgetDir.create(recursive: true);
      }

      // Download and create files
      await _spinnerHelper.runWithSpinner(
        message: 'Downloading ${selectedWidgets.length} widget(s)',
        action: () async {
          for (final widget in selectedWidgets) {
            final widgetName = widget.name!;
            try {
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
                  try {
                    final filePath = '$widgetsPath/$widgetName.dart';
                    await File(filePath)
                        .writeAsString(widgetWithContent.content!);
                    successfulDownloads.add(widgetName);
                  } catch (e) {
                    failedDownloads.add('$widgetName (file creation failed)');
                  }
                },
              );
            } catch (e) {
              failedDownloads.add(widgetName);
            }
          }
        },
      );

      // Show final results
      final successMessage = successfulDownloads.isNotEmpty
          ? '\n\x1B[32m✔ Successfully created:'
              '\n${successfulDownloads.map((n) => '  • $n.dart').join('\n')}\x1B[0m'
          : '';

      final errorMessage = failedDownloads.isNotEmpty
          ? '\n\x1B[31m✖ Failed to create:'
              '\n${failedDownloads.map((n) => '  • $n').join('\n')}\x1B[0m'
          : '';

      print([successMessage, errorMessage].join());

      if (successfulDownloads.isNotEmpty) {
        print('\nFiles created in: \x1B[36m$widgetsPath/\x1B[0m');
      }
    } catch (e, stackTrace) {
      print('\n❌ Unexpected error:');
      print(e);
      print(stackTrace);
    }
  }
}


// await _spinnerHelper.runWithSpinner(
//             message: 'downloading widgets',
//             action: () async {
//               for (final widget in selectedWidgets) {
//                 final result = await addUseCase(
//                     widget: WidgetEntity(
//                   name: widget.name,
//                   link: isDevMode()
//                       ? "${ApiConstants.widgetsDev}/${widget.link}"
//                       : "${ApiConstants.widgetsProd}/${widget.link}",
//                   content: "",
//                 ));
//                 result.fold(
//                   (failure) => print('Error: ${failure.message}'),
//                   (widget) => widget,
//                 );
//               }
//             },
//           );
//           print("\n");