import 'package:dartz/dartz.dart';
import 'package:flatcn_ui/src/core/errors/failures.dart';
import 'package:flatcn_ui/src/domain/repository/command_repository.dart';

class InitUseCase {
  final CommandRepository repository;

  InitUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    try {
      await repository.initializeProject();
      return Right(unit);
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
