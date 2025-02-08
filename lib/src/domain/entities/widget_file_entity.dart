import 'package:equatable/equatable.dart';

class WidgetFile extends Equatable {
  final String name;
  final String dir;
  final String content;
  const WidgetFile({
    required this.name,
    required this.dir,
    required this.content,
  });

  @override
  List<Object?> get props => [name, dir, content];
}
