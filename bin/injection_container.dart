// bin/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:flatcn_ui/src/domain/usecases/init_usecase.dart';
import 'package:flatcn_ui/src/data/repository/command_repository_impl.dart';
import 'package:flatcn_ui/src/data/services/command_interface_impl.dart';
import 'package:flatcn_ui/src/domain/repository/command_repository.dart';
import 'package:flatcn_ui/src/data/interfaces/command.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Use cases
  sl.registerLazySingleton(() => InitUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<CommandInterface>(
    () => CommandInterfaceImpl(),
  );
}