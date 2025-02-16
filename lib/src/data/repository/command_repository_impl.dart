import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
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
  Future<Either<Failure, Unit>> add({required String name, required String path}) {
    // TODO: implement add
    throw UnimplementedError();
  }
  
  
}
