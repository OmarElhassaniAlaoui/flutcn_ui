import 'package:flutcn_ui/src/data/interfaces/command.dart';
import 'package:flutcn_ui/src/data/models/init_config_model.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';

/// Manual mock for [CommandInterface].
///
/// Set [initException], [addException], or [listException] to make the
/// corresponding method throw. Otherwise they return default success values.
class MockCommandInterface implements CommandInterface {
  Exception? initException;
  Exception? addException;
  Exception? listException;

  WidgetModel addResult = const WidgetModel(
    name: 'button',
    link: '/widgets/button',
    content: 'class Button {}',
  );

  List<WidgetModel> listResult = const [];

  InitConfigModel? lastInitConfig;
  WidgetModel? lastAddWidget;

  @override
  Future<void> init({required InitConfigModel config}) async {
    lastInitConfig = config;
    if (initException != null) throw initException!;
  }

  @override
  Future<WidgetModel> add({required WidgetModel widget}) async {
    lastAddWidget = widget;
    if (addException != null) throw addException!;
    return addResult;
  }

  @override
  Future<List<WidgetModel>> list() async {
    if (listException != null) throw listException!;
    return listResult;
  }
}
