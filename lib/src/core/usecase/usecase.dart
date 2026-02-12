import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call({Params params});
}

class NoParams {
  const NoParams();
}
