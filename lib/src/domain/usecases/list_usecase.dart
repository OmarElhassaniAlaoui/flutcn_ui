import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class ListUseCase {
  final CommandRepository repository;

  ListUseCase(this.repository);

  Future<Either<Failure, List<WidgetEntity>>> call() async {
    return await repository.list();
  }
}
