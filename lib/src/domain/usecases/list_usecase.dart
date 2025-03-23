import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class ListUseCase {
  final CommandRepository repository;

  ListUseCase(this.repository);

  Future<List<WidgetEntity>> call() async {
    final result = await repository.list();
   
    return result.fold(
      (failure) => throw Exception(failure.message),
      (widgets) => widgets,
    );
  }
}
