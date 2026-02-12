import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/list_usecase.dart';
import 'package:test/test.dart';

import '../../mocks/mock_command_repository.dart';

void main() {
  late MockCommandRepository mockRepository;
  late ListUseCase useCase;

  setUp(() {
    mockRepository = MockCommandRepository();
    useCase = ListUseCase(mockRepository);
  });

  group('ListUseCase', () {
    test('returns Right(List<WidgetEntity>) on success', () async {
      const widgets = [
        WidgetEntity(name: 'button', link: '/widgets/button'),
        WidgetEntity(name: 'card', link: '/widgets/card'),
      ];
      mockRepository.listResult = const Right(widgets);

      final result = await useCase.call();

      result.fold(
        (_) => fail('Expected Right'),
        (list) {
          expect(list.length, 2);
          expect(list[0].name, 'button');
          expect(list[1].name, 'card');
        },
      );
    });

    test('returns Right([]) for empty list', () async {
      mockRepository.listResult = const Right([]);

      final result = await useCase.call();

      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('passes through OfflineFailure from repository', () async {
      mockRepository.listResult = Left(
        OfflineFailure(message: 'No internet connection'),
      );

      final result = await useCase.call();

      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('passes through ServerFailure from repository', () async {
      mockRepository.listResult = Left(
        ServerFailure(message: 'HTTP 500'),
      );

      final result = await useCase.call();

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'HTTP 500');
        },
        (_) => fail('Expected Left'),
      );
    });
  });
}
