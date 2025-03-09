import 'package:equatable/equatable.dart';
import 'package:flutcn_ui/src/data/models/init_config_model.dart';

class InitConfigEntity extends Equatable {
  final String themePath;
  final String widgetsPath;
  final String style;
  final String baseColor;
  final bool installGoogleFonts;
  // final String stateManagement;

  const InitConfigEntity({
    required this.themePath,
    required this.widgetsPath,
    required this.style,
    required this.baseColor,
    this.installGoogleFonts = false,
    // required this.stateManagement,
  });

  @override
  List<Object?> get props => [
        themePath,
        widgetsPath,
        style,
        baseColor,
        installGoogleFonts,
        // stateManagement,
      ];

  factory InitConfigEntity.fromJson(Map<String, dynamic> json) {
    return InitConfigEntity(
      themePath: json['themePath'],
      widgetsPath: json['widgetsPath'],
      style: json['style'],
      baseColor: json['baseColor'],
      installGoogleFonts: json['installGoogleFonts']??false,
      // stateManagement: json['stateManagement'],
    );
  }

  Map<String, dynamic> toJson() => {
        'themePath': themePath,
        'widgetsPath': widgetsPath,
        'style': style,
        'baseColor': baseColor,
        'installGoogleFonts': installGoogleFonts,
        // 'stateManagement': stateManagement,
      };

  toModel() => InitConfigModel.fromJson(toJson());
}
