import 'package:flutcn_ui/src/core/constants/api_constants.dart';
import 'package:flutcn_ui/src/core/services/api_service.dart';
import 'package:flutcn_ui/src/data/services/api_service.dart';
import 'package:flutcn_ui/src/domain/usecases/add_usecase.dart';
import 'package:flutcn_ui/src/domain/usecases/list_usecase.dart';
import 'package:flutcn_ui/src/domain/usecases/remove_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:flutcn_ui/src/domain/usecases/init_usecase.dart';
import 'package:flutcn_ui/src/data/repository/command_repository_impl.dart';
import 'package:flutcn_ui/src/data/services/command_interface_impl.dart';
import 'package:flutcn_ui/src/domain/repository/command_repository.dart';
import 'package:flutcn_ui/src/data/interfaces/command.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Use cases
  sl.registerLazySingleton(() => InitUseCase(sl()));
  sl.registerLazySingleton(() => AddUseCase(sl()));
  sl.registerLazySingleton(() => ListUseCase(sl()));
  sl.registerLazySingleton(() => RemoveUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<CommandInterface>(
    () => CommandInterfaceImpl(
      apiService: sl(),
    ),
  );

  sl.registerLazySingleton<ApiService>(
    () => HttpServiceImpl(
      baseUrl:  ApiConstants.baseProdUrl,
    ),
  );
}
