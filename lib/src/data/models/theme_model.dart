import 'package:flutcn_ui/src/data/models/widget_file_model.dart';
import 'package:flutcn_ui/src/domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  const ThemeModel({
    required super.name,
    required super.description,
    required super.image,
    required super.link,
    required List<WidgetFileModel> super.files,
  });
}
