import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:flutcn_ui/src/domain/usecases/remove_usecase.dart';
import 'package:test/test.dart';

import '../../mocks/mock_command_repository.dart';

void main() {
  late MockCommandRepository mockRepository;
  late RemoveUseCase useCase;

  const testWidget = WidgetEntity(name: 'button');
  const testWidgetsPath = 'lib/widgets';

  setUp(() {
    mockRepository = MockCommandRepository();
    useCase = RemoveUseCase(mockRepository);
  });

  group('RemoveUseCase', () {
    test('returns Right(unit) on success', () async {
      mockRepository.removeResult = const Right(unit);

      final result = await useCase.call(
        widget: testWidget,
        widgetsPath: testWidgetsPath,
      );

      result.fold(
        (_) => fail('Expected Right'),
        (value) => expect(value, unit),
      );
      expect(mockRepository.lastRemoveWidget, testWidget);
      expect(mockRepository.lastRemoveWidgetsPath, testWidgetsPath);
    });

    test('passes through ComponentNotFoundFailure from repository', () async {
      mockRepository.removeResult = Left(
        ComponentNotFoundFailure(message: 'Widget "button" not found'),
      );

      final result = await useCase.call(
        widget: testWidget,
        widgetsPath: testWidgetsPath,
      );

      result.fold(
        (failure) {
          expect(failure, isA<ComponentNotFoundFailure>());
          expect(failure.message, contains('button'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('passes through GenericFailure from repository', () async {
      mockRepository.removeResult = Left(
        GenericFailure(message: 'Unexpected error'),
      );

      final result = await useCase.call(
        widget: testWidget,
        widgetsPath: testWidgetsPath,
      );

      result.fold(
        (failure) => expect(failure, isA<GenericFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
