import 'package:equatable/equatable.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';
import 'package:flutcn_ui/src/domain/entities/widget_file_entity.dart';

class WidgetEntity extends Equatable {
  final String name;
  final String link;
  final List<WidgetFile> files;
  final String path ; 

  const WidgetEntity({
    required this.name,
    required this.link,
    required this.files,
    required this.path,
  });

  toModel() => WidgetModel.fromJSON(this);

  @override
  List<Object?> get props => [name, link, files , path];
}
