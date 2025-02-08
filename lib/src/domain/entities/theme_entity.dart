import 'package:equatable/equatable.dart';
import 'package:flatcn_ui/src/domain/entities/widget_file_entity.dart';

class ThemeEntity extends Equatable  { 
  final String name; 
  final String description;
  final String image;
  final String link;
  final List<WidgetFile> files;

  const ThemeEntity({
    required this.name,
    required this.description,
    required this.image,
    required this.link,
    required this.files,
  });

  @override 
  List<Object?> get props => [name, description, image, link, files];
}