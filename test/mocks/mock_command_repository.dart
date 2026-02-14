import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

/// Manual mock for [CommandRepository].
///
/// Set [initResult], [addResult], or [listResult] to control what each
/// method returns.
class MockCommandRepository implements CommandRepository {
  Either<Failure, Unit> initResult = const Right(unit);
  Either<Failure, WidgetEntity> addResult = const Right(
    WidgetEntity(name: 'button', link: '/widgets/button', content: 'class Button {}'),
  );
  Either<Failure, List<WidgetEntity>> listResult = const Right([]);
  Either<Failure, Unit> removeResult = const Right(unit);
  Either<Failure, WidgetEntity> updateResult = const Right(
    WidgetEntity(name: 'button', link: '/widgets/button', content: 'class Button {}'),
  );

  InitConfigEntity? lastInitConfig;
  WidgetEntity? lastAddWidget;
  WidgetEntity? lastRemoveWidget;
  String? lastRemoveWidgetsPath;
  WidgetEntity? lastUpdateWidget;
  String? lastUpdateWidgetsPath;

  @override
  Future<Either<Failure, Unit>> initializeProject({
    required InitConfigEntity config,
  }) async {
    lastInitConfig = config;
    return initResult;
  }

  @override
  Future<Either<Failure, WidgetEntity>> add({
    required WidgetEntity widget,
  }) async {
    lastAddWidget = widget;
    return addResult;
  }

  @override
  Future<Either<Failure, List<WidgetEntity>>> list() async {
    return listResult;
  }

  @override
  Future<Either<Failure, Unit>> remove({
    required WidgetEntity widget,
    required String widgetsPath,
  }) async {
    lastRemoveWidget = widget;
    lastRemoveWidgetsPath = widgetsPath;
    return removeResult;
  }

  @override
  Future<Either<Failure, WidgetEntity>> update({
    required WidgetEntity widget,
    required String widgetsPath,
  }) async {
    lastUpdateWidget = widget;
    lastUpdateWidgetsPath = widgetsPath;
    return updateResult;
  }
}
