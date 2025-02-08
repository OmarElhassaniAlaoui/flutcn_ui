import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/repository/command_repository.dart';
import '../interfaces/command.dart';

class CommandRepositoryImpl implements CommandRepository {
  final CommandInterface commandInterface;

  CommandRepositoryImpl(this.commandInterface);

  @override
  Future<Either<Failure, void>> initializeProject() async {
    try {
      await commandInterface.init();
      return const Right(null);
    } catch (e) {
      return Left(InitializationFailure());
    }
  }
}