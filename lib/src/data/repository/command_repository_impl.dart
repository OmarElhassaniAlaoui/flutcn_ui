import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import '../../core/errors/failures.dart';
import '../../domain/repository/command_repository.dart';
import '../interfaces/command.dart';

class CommandRepositoryImpl implements CommandRepository {
  final CommandInterface commandInterface;

  CommandRepositoryImpl(this.commandInterface);

  @override
  Future<Either<Failure, Unit>> initializeProject({
    required InitConfigEntity config,
  }) async {
    try {
      await commandInterface.init(
        config: config.toModel(),
      );
      return const Right(unit);
    } catch (e) {
      return Left(InitializationFailure());
    }
  }

  @override
  Future<Either<Failure, WidgetEntity>> add(
      {required WidgetEntity widget}) async {
    try {
      WidgetModel result = await commandInterface.add(
        widget: widget.toModel(),
      );
      return Right(result); 
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
