import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import '../../core/errors/failures.dart';

abstract class CommandRepository {
  Future<Either<Failure, Unit>> initializeProject({
    required InitConfigEntity config,
  });
}
