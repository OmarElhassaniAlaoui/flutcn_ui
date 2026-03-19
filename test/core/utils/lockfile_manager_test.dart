import 'dart:convert';
import 'dart:io';

import 'package:flutcn_ui/src/core/utils/lockfile_manager.dart';
import 'package:test/test.dart';

void main() {
  const lockfileName = LockfileManager.lockfileName;

  setUp(() {
    // Clean up any existing lockfile before each test
    final file = File(lockfileName);
    if (file.existsSync()) file.deleteSync();
  });

  tearDown(() {
    // Clean up after each test
    final file = File(lockfileName);
    if (file.existsSync()) file.deleteSync();
  });

  group('computeHash', () {
    test('returns consistent SHA-256 for same content', () {
      const content = 'class Button extends StatelessWidget {}';
      final hash1 = LockfileManager.computeHash(content);
      final hash2 = LockfileManager.computeHash(content);
      expect(hash1, equals(hash2));
      expect(hash1, startsWith('sha256:'));
    });

    test('returns different hashes for different content', () {
      final hash1 = LockfileManager.computeHash('class Button {}');
      final hash2 = LockfileManager.computeHash('class Card {}');
      expect(hash1, isNot(equals(hash2)));
    });
  });

  group('readLockfile', () {
    test('returns empty structure when file does not exist', () {
      final lockfile = LockfileManager.readLockfile();
      expect(lockfile['lockfileVersion'], equals(1));
      expect(lockfile['widgets'], isA<Map>());
      expect((lockfile['widgets'] as Map).isEmpty, isTrue);
    });

    test('parses valid lockfile correctly', () {
      final data = {
        'lockfileVersion': 1,
        'widgets': {
          'button': {
            'style': 'new-york',
            'contentHash': 'sha256:abc123',
            'installedAt': '2026-02-14T10:00:00.000Z',
          }
        }
      };
      File(lockfileName).writeAsStringSync(jsonEncode(data));

      final lockfile = LockfileManager.readLockfile();
      expect(lockfile['lockfileVersion'], equals(1));
      final widgets = lockfile['widgets'] as Map<String, dynamic>;
      expect(widgets.containsKey('button'), isTrue);
      final button = widgets['button'] as Map<String, dynamic>;
      expect(button['style'], equals('new-york'));
      expect(button['contentHash'], equals('sha256:abc123'));
    });
  });

  group('writeLockfile', () {
    test('creates valid JSON file', () {
      final data = {'lockfileVersion': 1, 'widgets': <String, dynamic>{}};
      LockfileManager.writeLockfile(data);

      final file = File(lockfileName);
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();
      final parsed = jsonDecode(content) as Map<String, dynamic>;
      expect(parsed['lockfileVersion'], equals(1));
      expect(parsed['widgets'], isA<Map>());
    });
  });

  group('recordWidget', () {
    test('adds new widget entry', () {
      const widgetContent = 'class Button extends StatelessWidget {}';
      LockfileManager.recordWidget('button', 'new-york', widgetContent);

      final lockfile = LockfileManager.readLockfile();
      final widgets = lockfile['widgets'] as Map<String, dynamic>;
      expect(widgets.containsKey('button'), isTrue);

      final button = widgets['button'] as Map<String, dynamic>;
      expect(button['style'], equals('new-york'));
      expect(button['contentHash'],
          equals(LockfileManager.computeHash(widgetContent)));
      expect(button['installedAt'], isNotNull);
    });

    test('updates existing widget entry with new hash', () {
      LockfileManager.recordWidget('button', 'new-york', 'version 1');
      final hash1 = LockfileManager.getWidget('button')!['contentHash'];

      LockfileManager.recordWidget('button', 'new-york', 'version 2');
      final hash2 = LockfileManager.getWidget('button')!['contentHash'];

      expect(hash1, isNot(equals(hash2)));
    });

    test('preserves other widgets when adding new one', () {
      LockfileManager.recordWidget('button', 'new-york', 'button code');
      LockfileManager.recordWidget('card', 'new-york', 'card code');

      final lockfile = LockfileManager.readLockfile();
      final widgets = lockfile['widgets'] as Map<String, dynamic>;
      expect(widgets.length, equals(2));
      expect(widgets.containsKey('button'), isTrue);
      expect(widgets.containsKey('card'), isTrue);
    });
  });

  group('removeWidget', () {
    test('deletes widget entry from lockfile', () {
      LockfileManager.recordWidget('button', 'new-york', 'content');
      expect(LockfileManager.getWidget('button'), isNotNull);

      LockfileManager.removeWidget('button');
      expect(LockfileManager.getWidget('button'), isNull);
    });

    test('does not fail when removing non-existent widget', () {
      LockfileManager.writeLockfile(
          {'lockfileVersion': 1, 'widgets': <String, dynamic>{}});
      expect(
          () => LockfileManager.removeWidget('nonexistent'), returnsNormally);
    });
  });

  group('getWidget', () {
    test('returns null for missing widget', () {
      expect(LockfileManager.getWidget('nonexistent'), isNull);
    });

    test('returns widget entry when tracked', () {
      LockfileManager.recordWidget('button', 'new-york', 'content');
      final entry = LockfileManager.getWidget('button');
      expect(entry, isNotNull);
      expect(entry!['style'], equals('new-york'));
    });
  });

  group('isUpToDate', () {
    test('returns true for matching content', () {
      const content = 'class Button {}';
      LockfileManager.recordWidget('button', 'new-york', content);
      expect(LockfileManager.isUpToDate('button', content), isTrue);
    });

    test('returns false for different content', () {
      LockfileManager.recordWidget('button', 'new-york', 'version 1');
      expect(LockfileManager.isUpToDate('button', 'version 2'), isFalse);
    });

    test('returns false for untracked widget', () {
      expect(LockfileManager.isUpToDate('unknown', 'content'), isFalse);
    });
  });

  group('lockfileExists', () {
    test('returns false when no lockfile', () {
      expect(LockfileManager.lockfileExists(), isFalse);
    });

    test('returns true after writing lockfile', () {
      LockfileManager.writeLockfile(
          {'lockfileVersion': 1, 'widgets': <String, dynamic>{}});
      expect(LockfileManager.lockfileExists(), isTrue);
    });
  });
}
