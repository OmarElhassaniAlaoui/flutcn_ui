import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';
import 'package:test/test.dart';

void main() {
  group('InitConfigEntity.fromJson', () {
    final validJson = {
      'themePath': 'lib/themes',
      'widgetsPath': 'lib/widgets',
      'style': 'new-york',
      'baseColor': 'zinc',
      'installGoogleFonts': true,
    };

    test('creates entity from valid JSON', () {
      final entity = InitConfigEntity.fromJson(validJson);

      expect(entity.themePath, 'lib/themes');
      expect(entity.widgetsPath, 'lib/widgets');
      expect(entity.style, 'new-york');
      expect(entity.baseColor, 'zinc');
      expect(entity.installGoogleFonts, true);
    });

    test('defaults installGoogleFonts to false when omitted', () {
      final json = Map<String, dynamic>.from(validJson)
        ..remove('installGoogleFonts');

      final entity = InitConfigEntity.fromJson(json);

      expect(entity.installGoogleFonts, false);
    });

    test('defaults installGoogleFonts to false when null', () {
      final json = Map<String, dynamic>.from(validJson)
        ..['installGoogleFonts'] = null;

      final entity = InitConfigEntity.fromJson(json);

      expect(entity.installGoogleFonts, false);
    });

    test('throws on missing themePath', () {
      final json = Map<String, dynamic>.from(validJson)..remove('themePath');

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('themePath'),
        )),
      );
    });

    test('throws on missing widgetsPath', () {
      final json = Map<String, dynamic>.from(validJson)..remove('widgetsPath');

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('widgetsPath'),
        )),
      );
    });

    test('throws on missing style', () {
      final json = Map<String, dynamic>.from(validJson)..remove('style');

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('style'),
        )),
      );
    });

    test('throws on missing baseColor', () {
      final json = Map<String, dynamic>.from(validJson)..remove('baseColor');

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('baseColor'),
        )),
      );
    });

    test('throws on null required field', () {
      final json = Map<String, dynamic>.from(validJson)..['style'] = null;

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('style'),
        )),
      );
    });

    test('throws on non-string required field', () {
      final json = Map<String, dynamic>.from(validJson)..['themePath'] = 123;

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('must be a string'),
        )),
      );
    });

    test('throws on non-bool installGoogleFonts', () {
      final json = Map<String, dynamic>.from(validJson)
        ..['installGoogleFonts'] = 'yes';

      expect(
        () => InitConfigEntity.fromJson(json),
        throwsA(isA<InvalidConfigFileException>().having(
          (e) => e.message,
          'message',
          contains('installGoogleFonts'),
        )),
      );
    });
  });

  group('InitConfigEntity.toJson', () {
    test('round-trips through toJson and fromJson', () {
      const entity = InitConfigEntity(
        themePath: 'lib/themes',
        widgetsPath: 'lib/widgets',
        style: 'default',
        baseColor: 'blue',
        installGoogleFonts: true,
      );

      final json = entity.toJson();
      final restored = InitConfigEntity.fromJson(json);

      expect(restored, entity);
    });
  });

  group('InitConfigEntity equality', () {
    test('two entities with same values are equal', () {
      const a = InitConfigEntity(
        themePath: 'lib/themes',
        widgetsPath: 'lib/widgets',
        style: 'new-york',
        baseColor: 'zinc',
      );
      const b = InitConfigEntity(
        themePath: 'lib/themes',
        widgetsPath: 'lib/widgets',
        style: 'new-york',
        baseColor: 'zinc',
      );

      expect(a, b);
    });

    test('entities with different values are not equal', () {
      const a = InitConfigEntity(
        themePath: 'lib/themes',
        widgetsPath: 'lib/widgets',
        style: 'new-york',
        baseColor: 'zinc',
      );
      const b = InitConfigEntity(
        themePath: 'lib/themes',
        widgetsPath: 'lib/widgets',
        style: 'default',
        baseColor: 'zinc',
      );

      expect(a, isNot(b));
    });
  });
}
