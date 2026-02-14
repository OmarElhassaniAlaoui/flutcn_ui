import 'package:equatable/equatable.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
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
    _validateRequiredString(json, 'themePath');
    _validateRequiredString(json, 'widgetsPath');
    _validateRequiredString(json, 'style');
    _validateRequiredString(json, 'baseColor');

    if (json.containsKey('installGoogleFonts') &&
        json['installGoogleFonts'] != null &&
        json['installGoogleFonts'] is! bool) {
      throw InvalidConfigFileException(
        message:
            'Field "installGoogleFonts" must be a boolean in flutcn.config.json',
      );
    }

    return InitConfigEntity(
      themePath: json['themePath'] as String,
      widgetsPath: json['widgetsPath'] as String,
      style: json['style'] as String,
      baseColor: json['baseColor'] as String,
      installGoogleFonts: json['installGoogleFonts'] as bool? ?? false,
    );
  }

  static void _validateRequiredString(Map<String, dynamic> json, String field) {
    if (!json.containsKey(field) || json[field] == null) {
      throw InvalidConfigFileException(
        message: 'Missing required field "$field" in flutcn.config.json',
      );
    }
    if (json[field] is! String) {
      throw InvalidConfigFileException(
        message: 'Field "$field" must be a string in flutcn.config.json',
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'themePath': themePath,
        'widgetsPath': widgetsPath,
        'style': style,
        'baseColor': baseColor,
        'installGoogleFonts': installGoogleFonts,
        // 'stateManagement': stateManagement,
      };

  InitConfigModel toModel() => InitConfigModel.fromJson(toJson());
}
