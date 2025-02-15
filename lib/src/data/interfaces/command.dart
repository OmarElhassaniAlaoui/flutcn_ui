import 'package:flutcn_ui/src/data/models/init_config_model.dart';

abstract class CommandInterface {
  Future<void> init({
    required InitConfigModel config,
  });
}
