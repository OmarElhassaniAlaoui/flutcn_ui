import 'package:flatcn_ui/src/domain/entities/init_config_entity.dart';

class InitConfigModel extends InitConfigEntity {
  const InitConfigModel({
    required super.themePath,
    required super.widgetsPath,
    required super.style,
    required super.baseColor,
    required super.stateManagement,
  });

  factory InitConfigModel.fromJson(Map<String, dynamic> json) {
    return InitConfigModel(
      themePath: json['themePath'],
      widgetsPath: json['widgetsPath'],
      style: json['style'],
      baseColor: json['baseColor'],
      stateManagement: json['stateManagement'],
    );
  }

  Map<String, dynamic> toJson() => {
        'themePath': themePath,
        'widgetsPath': widgetsPath,
        'style': style,
        'baseColor': baseColor,
        'stateManagement': stateManagement,
      };
}
