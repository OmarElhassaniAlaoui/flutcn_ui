import 'package:flatcn_ui/src/data/models/widget_file_model.dart';
import 'package:flatcn_ui/src/domain/entities/widget_entity.dart';

class WidgetModel extends WidgetEntity {
  const WidgetModel({
    required super.name,
    required super.description,
    required super.image,
    required super.link,
    required List<WidgetFileModel> super.files,
  });


}
