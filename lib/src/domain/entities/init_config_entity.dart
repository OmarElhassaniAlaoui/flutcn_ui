import 'package:equatable/equatable.dart';

class InitConfigEntity extends Equatable {
  final String themePath;
  final String widgetsPath;
  final String style;
  final String baseColor;
  final String stateManagement;

  const InitConfigEntity({
    required this.themePath,
    required this.widgetsPath,
    required this.style,
    required this.baseColor,
    required this.stateManagement,
  });

  @override
  List<Object?> get props => [
        themePath,
        widgetsPath,
        style,
        baseColor,
        stateManagement,
      ];

  factory InitConfigEntity.fromJson(Map<String, dynamic> json) {
    return InitConfigEntity(
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
