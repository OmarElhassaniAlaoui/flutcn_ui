import 'package:flutcn_ui/src/data/models/init_config_model.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';

abstract class CommandInterface {
  Future<void> init({
    required InitConfigModel config,
  });

  Future<WidgetModel> add({
    required  WidgetModel widget,
  });
}
