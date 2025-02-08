import 'package:dartz/dartz.dart';
import 'package:flatcn_ui/src/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call({Params params});
}
