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
    late Set<WidgetEntity> selectedWidgets;
    try {
      await _spinnerHelper.runWithSpinner(
        message: 'Fetching widgets',
        onSuccess: "fetched widgets",
        action: () async {
          final widgets = await listUseCase.call();
          print("\nAvailable Widgets:");
          print("use arrow keys to navigate and space to select");
          final chosenWidgets = MultiCheckboxListChooser(
                  options: widgets.map((e) => e.name!).toList())
              .choose();

          selectedWidgets = widgets
              .where((element) => chosenWidgets.contains(element.name!))
              .toSet();
        },
        onError: 'Error fetching widgets',
      );

      // download widgets
      await _spinnerHelper.runWithSpinner(
        message: 'downloading widgets',
        action: () async {
          if (!File('flutcn.config.json').existsSync()) {
            print('Flutcn UI is not initialized. Please run "flutcn_ui init"');
            return;
          }

          for (final widget in selectedWidgets) {
            final result = await addUseCase(
                widget: WidgetEntity(
              name: widget.name,
              link: isDevMode()
                  ? "${ApiConstants.widgetsDev}/${widget.link}"
                  : "${ApiConstants.widgetsProd}/${widget.link}",
              content: "",
            ));
             result.fold(
              (failure) => print('Error: ${failure.message}'),
              (widget) => widget,
            );
          }


          
        },
        onSuccess:
            "Successfully downloaded ${selectedWidgets.map((e) => e.name!).join(', ')} widgets",
        onError:
            "Error downloading ${selectedWidgets.map((e) => e.name!).join(', ')} widgets",
      );
    } catch (e, stackTrace) {
      print('\n❌ Error in ListCommand:');
      print(e);
      print(stackTrace);
    }
  }
}
