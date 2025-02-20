import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';

class WidgetModel extends WidgetEntity {
  const WidgetModel({
    required super.name,
    required super.link,
    required super.content,
  });

  factory WidgetModel.fromJSON(WidgetEntity entity) {
    return WidgetModel(
      name: entity.name,
      link: entity.link,
      content: entity.content,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'content': content,
      };
}
