import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';

class WidgetModel extends WidgetEntity {
  const WidgetModel({
    required super.name,
    required super.link,
    required super.files,
    required super.path,
  });

  factory WidgetModel.fromJSON(WidgetEntity entity) {
    return WidgetModel(
      name: entity.name,
      link: entity.link,
      files: entity.files,
      path: entity.path,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'files': files,
        'path': path,
      };
}
