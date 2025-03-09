import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';

class InitConfigModel extends InitConfigEntity {
  const InitConfigModel({
    required super.themePath,
    required super.widgetsPath,
    required super.style,
    required super.baseColor,
    required super.installGoogleFonts,
    // required super.stateManagement,
  });

  factory InitConfigModel.fromJson(Map<String, dynamic> json) {
    return InitConfigModel(
      themePath: json['themePath'],
      widgetsPath: json['widgetsPath'],
      style: json['style'],
      baseColor: json['baseColor'],
      installGoogleFonts: json['installGoogleFonts'] ?? false,
      // stateManagement: json['stateManagement'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'themePath': themePath,
        'widgetsPath': widgetsPath,
        'style': style,
        'baseColor': baseColor,
        'installGoogleFonts': installGoogleFonts,
        // 'stateManagement': stateManagement,
      };
}
