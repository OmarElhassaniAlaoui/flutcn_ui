import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class RemoveUseCase {
  final CommandRepository repository;

  RemoveUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required WidgetEntity widget,
    required String widgetsPath,
  }) async {
    return await repository.remove(widget: widget, widgetsPath: widgetsPath);
  }
}
