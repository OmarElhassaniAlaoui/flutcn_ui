
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class CommandRepository {
  Future<Either<Failure, void>> initializeProject();
}