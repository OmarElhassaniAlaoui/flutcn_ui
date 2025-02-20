import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class AddUseCase {
  final CommandRepository repository;

  AddUseCase(this.repository);

  Future<Either<Failure, WidgetEntity>> call({
    required WidgetEntity widget,
  }) async {
    return await repository.add(widget: widget);
  }
}
