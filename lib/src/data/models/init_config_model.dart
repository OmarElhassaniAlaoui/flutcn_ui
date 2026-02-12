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
    // Validation is handled by InitConfigEntity.fromJson()
    final entity = InitConfigEntity.fromJson(json);
    return InitConfigModel(
      themePath: entity.themePath,
      widgetsPath: entity.widgetsPath,
      style: entity.style,
      baseColor: entity.baseColor,
      installGoogleFonts: entity.installGoogleFonts,
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
