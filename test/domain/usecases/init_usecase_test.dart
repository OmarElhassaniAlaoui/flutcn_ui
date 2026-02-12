import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/init_usecase.dart';
import 'package:test/test.dart';

import '../../mocks/mock_command_repository.dart';

void main() {
  late MockCommandRepository mockRepository;
  late InitUseCase useCase;

  const testConfig = InitConfigEntity(
    themePath: 'lib/themes',
    widgetsPath: 'lib/widgets',
    style: 'new-york',
    baseColor: 'zinc',
  );

  setUp(() {
    mockRepository = MockCommandRepository();
    useCase = InitUseCase(mockRepository);
  });

  group('InitUseCase', () {
    test('returns Right(unit) on success', () async {
      mockRepository.initResult = const Right(unit);

      final result = await useCase.call(config: testConfig);

      expect(result, const Right(unit));
      expect(mockRepository.lastInitConfig, testConfig);
    });

    test('passes through OfflineFailure from repository', () async {
      mockRepository.initResult = Left(
        OfflineFailure(message: 'No internet connection'),
      );

      final result = await useCase.call(config: testConfig);

      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left — InitUseCase should propagate failures'),
      );
    });

    test('passes through ThemeNotFoundFailure from repository', () async {
      mockRepository.initResult = Left(
        ThemeNotFoundFailure(message: 'Theme not found'),
      );

      final result = await useCase.call(config: testConfig);

      result.fold(
        (failure) {
          expect(failure, isA<ThemeNotFoundFailure>());
          expect(failure.message, 'Theme not found');
        },
        (_) => fail('Expected Left — InitUseCase should propagate failures'),
      );
    });

    test('passes through InitializationFailure from repository', () async {
      mockRepository.initResult = Left(InitializationFailure());

      final result = await useCase.call(config: testConfig);

      result.fold(
        (failure) => expect(failure, isA<InitializationFailure>()),
        (_) => fail('Expected Left — InitUseCase should propagate failures'),
      );
    });
  });
}
