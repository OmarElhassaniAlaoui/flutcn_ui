import 'package:dartz/dartz.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/errors/failures.dart';
import 'package:flutcn_ui/src/data/models/widget_model.dart';
import 'package:flutcn_ui/src/data/repository/command_repository_impl.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:flutcn_ui/src/domain/entities/widget_entity.dart';
import 'package:test/test.dart';

import '../../mocks/mock_command_interface.dart';

void main() {
  late MockCommandInterface mockInterface;
  late CommandRepositoryImpl repository;

  const testConfig = InitConfigEntity(
    themePath: 'lib/themes',
    widgetsPath: 'lib/widgets',
    style: 'new-york',
    baseColor: 'zinc',
  );

  const testWidget = WidgetEntity(
    name: 'button',
    link: '/widgets/button',
  );

  setUp(() {
    mockInterface = MockCommandInterface();
    repository = CommandRepositoryImpl(mockInterface);
  });

  group('initializeProject', () {
    test('returns Right(unit) on success', () async {
      final result = await repository.initializeProject(config: testConfig);

      expect(result, const Right(unit));
      expect(mockInterface.lastInitConfig?.themePath, 'lib/themes');
    });

    test('returns Left(OfflineFailure) on OfflineException', () async {
      mockInterface.initException = OfflineException();

      final result = await repository.initializeProject(config: testConfig);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ThemeNotFoundFailure) on ThemeNotFoundException',
        () async {
      mockInterface.initException = ThemeNotFoundException(
        message: 'Theme not found for style "foo"',
      );

      final result = await repository.initializeProject(config: testConfig);

      result.fold(
        (failure) {
          expect(failure, isA<ThemeNotFoundFailure>());
          expect(failure.message, contains('Theme not found'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      mockInterface.initException = ServerException(message: 'Timeout');

      final result = await repository.initializeProject(config: testConfig);

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Timeout');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(InvalidConfigFileFailure) on InvalidConfigFileException',
        () async {
      mockInterface.initException = InvalidConfigFileException(
        message: 'Missing "themePath"',
      );

      final result = await repository.initializeProject(config: testConfig);

      result.fold(
        (failure) {
          expect(failure, isA<InvalidConfigFileFailure>());
          expect(failure.message, contains('themePath'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(InitializationFailure) on unknown exception', () async {
      mockInterface.initException = Exception('something unexpected');

      final result = await repository.initializeProject(config: testConfig);

      result.fold(
        (failure) => expect(failure, isA<InitializationFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('add', () {
    test('returns Right(WidgetEntity) on success', () async {
      mockInterface.addResult = const WidgetModel(
        name: 'button',
        link: '/widgets/button',
        content: 'class Button extends StatelessWidget {}',
      );

      final result = await repository.add(widget: testWidget);

      result.fold(
        (_) => fail('Expected Right'),
        (widget) {
          expect(widget.name, 'button');
          expect(widget.content, contains('StatelessWidget'));
        },
      );
    });

    test('returns Left(OfflineFailure) on OfflineException', () async {
      mockInterface.addException = OfflineException();

      final result = await repository.add(widget: testWidget);

      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ComponentNotFoundFailure) on ComponentNotFoundException',
        () async {
      mockInterface.addException = ComponentNotFoundException(
        message: 'Widget "foo" not found',
      );

      final result = await repository.add(widget: testWidget);

      result.fold(
        (failure) {
          expect(failure, isA<ComponentNotFoundFailure>());
          expect(failure.message, contains('foo'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      mockInterface.addException = ServerException(message: 'HTTP 500');

      final result = await repository.add(widget: testWidget);

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'HTTP 500');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(GenericFailure) on unknown exception', () async {
      mockInterface.addException = Exception('unexpected');

      final result = await repository.add(widget: testWidget);

      result.fold(
        (failure) => expect(failure, isA<GenericFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('list', () {
    test('returns Right(List<WidgetModel>) on success', () async {
      mockInterface.listResult = const [
        WidgetModel(name: 'button', link: '/widgets/button'),
        WidgetModel(name: 'card', link: '/widgets/card'),
      ];

      final result = await repository.list();

      result.fold(
        (_) => fail('Expected Right'),
        (widgets) {
          expect(widgets.length, 2);
          expect(widgets[0].name, 'button');
          expect(widgets[1].name, 'card');
        },
      );
    });

    test('returns Right([]) for empty list', () async {
      mockInterface.listResult = const [];

      final result = await repository.list();

      result.fold(
        (_) => fail('Expected Right'),
        (widgets) => expect(widgets, isEmpty),
      );
    });

    test('returns Left(OfflineFailure) on OfflineException', () async {
      mockInterface.listException = OfflineException();

      final result = await repository.list();

      result.fold(
        (failure) => expect(failure, isA<OfflineFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      mockInterface.listException = ServerException(
        message: 'Failed to fetch widgets (HTTP 500)',
      );

      final result = await repository.list();

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('500'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(GenericFailure) on unknown exception', () async {
      mockInterface.listException = Exception('unexpected');

      final result = await repository.list();

      result.fold(
        (failure) => expect(failure, isA<GenericFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
