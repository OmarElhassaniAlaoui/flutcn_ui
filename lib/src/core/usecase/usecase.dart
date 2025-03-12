import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call({Params params});
}

class NoParams {
  const NoParams();
}
