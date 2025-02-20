import 'package:equatable/equatable.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';

class WidgetEntity extends Equatable {
  final String name;
  final String link;
  final String content ; 

  const WidgetEntity({
    required this.name,
    required this.link,
    required this.content,
  });

  toModel() => WidgetModel.fromJSON(this);

  @override
  List<Object?> get props => [name, link, content ];
}
