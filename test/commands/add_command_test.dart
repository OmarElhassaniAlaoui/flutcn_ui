import 'package:test/test.dart';

import '../../bin/commands/add.dart';

void main() {
  group('AddCommand argParser', () {
    late AddCommand command;

    setUp(() {
      command = AddCommand();
    });

    test('registers --path option', () {
      final options = command.argParser.options;
      expect(options.containsKey('path'), isTrue);
    });

    test('--path option has abbreviation -p', () {
      final pathOption = command.argParser.options['path']!;
      expect(pathOption.abbr, 'p');
    });

    test('--path option accepts a string value', () {
      final pathOption = command.argParser.options['path']!;
      expect(pathOption.isFlag, isFalse);
    });

    test('--path defaults to null when not provided', () {
      final results = command.argParser.parse([]);
      expect(results['path'], isNull);
    });

    test('--path captures the provided value', () {
      final results = command.argParser.parse(['--path', 'lib/components']);
      expect(results['path'], 'lib/components');
    });

    test('-p short form captures the provided value', () {
      final results = command.argParser.parse(['-p', 'lib/components']);
      expect(results['path'], 'lib/components');
    });

    test('--path works alongside positional arguments', () {
      final results =
          command.argParser.parse(['--path', 'lib/components', 'button']);
      expect(results['path'], 'lib/components');
      expect(results.rest, contains('button'));
    });
  });
}
