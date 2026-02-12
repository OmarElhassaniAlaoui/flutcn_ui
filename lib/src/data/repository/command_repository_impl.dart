import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
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
    } on OfflineException {
      return Left(OfflineFailure(message: 'No internet connection'));
    } on ThemeNotFoundException catch (e) {
      return Left(ThemeNotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on InvalidConfigFileException catch (e) {
      return Left(InvalidConfigFileFailure(message: e.message));
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
    } on OfflineException {
      return Left(OfflineFailure(message: 'No internet connection'));
    } on ComponentNotFoundException catch (e) {
      return Left(ComponentNotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WidgetModel>>> list() async {
    try {
      final widgets = await commandInterface.list();
      return Right(widgets);
    } on OfflineException {
      return Left(OfflineFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
