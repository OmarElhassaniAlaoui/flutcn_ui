import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';

class InitUseCase {
  final CommandRepository repository;

  InitUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required InitConfigEntity config,
  }) async {
    try {
      await repository.initializeProject(
        config: config,
      );
      return Right(unit);
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
