import 'package:equatable/equatable.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';

class WidgetEntity extends Equatable {
  final String? name;
  final String? link;
  final String? content;
  final String? style;

  const WidgetEntity({this.name, this.link, this.content, this.style});

  toModel() => WidgetModel.fromJSON(toJson());

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'content': content,
        'style': style,
      };

  @override
  List<Object?> get props => [name, link, content, style];
}
