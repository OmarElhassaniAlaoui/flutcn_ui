import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';

class WidgetModel extends WidgetEntity {
  const WidgetModel({
    super.name,
    super.link,
    super.content,
    super.style,
  });

  factory WidgetModel.fromJSON(Map<String, dynamic> json) {
    return WidgetModel(
      name: json['name'],
      link: json['link'],
      content: json['content'],
      style: json['style'],
    );
  } 
  
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'content': content,
        'style': style,
      };
}
