import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/add_usecase.dart';
import 'package:test/test.dart';

import '../../mocks/mock_command_repository.dart';

void main() {
  late MockCommandRepository mockRepository;
  late AddUseCase useCase;

  const testWidget = WidgetEntity(
    name: 'button',
    link: '/widgets/button',
  );

  setUp(() {
    mockRepository = MockCommandRepository();
    useCase = AddUseCase(mockRepository);
  });

  group('AddUseCase', () {
    test('returns Right(WidgetEntity) on success', () async {
      const expected = WidgetEntity(
        name: 'button',
        link: '/widgets/button',
        content: 'class Button {}',
      );
      mockRepository.addResult = const Right(expected);

      final result = await useCase.call(widget: testWidget);

      result.fold(
        (_) => fail('Expected Right'),
        (widget) {
          expect(widget.name, 'button');
          expect(widget.content, 'class Button {}');
        },
      );
      expect(mockRepository.lastAddWidget, testWidget);
    });

    test('passes through OfflineFailure from repository', () async {
      mockRepository.addResult = Left(
        OfflineFailure(message: 'No internet connection'),
      );

      final result = await useCase.call(widget: testWidget);

      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('passes through ComponentNotFoundFailure from repository', () async {
      mockRepository.addResult = Left(
        ComponentNotFoundFailure(message: 'Widget "foo" not found'),
      );

      final result = await useCase.call(widget: testWidget);

      result.fold(
        (failure) {
          expect(failure, isA<ComponentNotFoundFailure>());
          expect(failure.message, contains('foo'));
        },
        (_) => fail('Expected Left'),
      );
    });
  });
}
