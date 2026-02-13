import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import '../../core/errors/failures.dart';

abstract class CommandRepository {
  Future<Either<Failure, Unit>> initializeProject({
    required InitConfigEntity config,
  });

  Future<Either<Failure, WidgetEntity>> add({
    required WidgetEntity widget,
  });

  Future<Either<Failure,List<WidgetEntity>>> list() ;

  Future<Either<Failure, Unit>> remove({
    required WidgetEntity widget,
    required String widgetsPath,
  });
}
