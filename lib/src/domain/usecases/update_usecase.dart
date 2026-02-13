import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class UpdateUseCase {
  final CommandRepository repository;

  UpdateUseCase(this.repository);

  Future<Either<Failure, WidgetEntity>> call({
    required WidgetEntity widget,
    required String widgetsPath,
  }) async {
    return await repository.update(widget: widget, widgetsPath: widgetsPath);
  }
}