import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import '../../core/errors/failures.dart';

abstract class CommandRepository {
  Future<Either<Failure, Unit>> initializeProject({
    required InitConfigEntity config,
  });

  Future<Either<Failure, Unit>> add({
    required String name,
    required String path,
  });

//   Future<Either<Failure, Unit>> remove({
//     required String name,
//   });

//   Future<Either<Failure, Unit>> update({
//     required String name,
//     required String path,
//   });

//   Future<Either<Failure, List<String>>> list();
}
