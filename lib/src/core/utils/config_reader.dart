import 'dart:convert';
import 'dart:io';

import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/domain/entities/init_config_entity.dart';

class ConfigReader {
  static const String configFileName = 'flutcn.config.json';

  /// Reads and validates the config file, returning a typed entity.
  static Future<InitConfigEntity> readConfig() async {
    final file = File(configFileName);

    if (!file.existsSync()) {
      throw InvalidConfigFileException(
        message: 'Config file not found. Run "flutcn_ui init" first.',
      );
    }

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return InitConfigEntity.fromJson(json); // Validation happens here
    } on FormatException catch (e) {
      throw InvalidConfigFileException(
        message: 'Invalid JSON in $configFileName: ${e.message}',
      );
    } on InvalidConfigFileException {
      rethrow;
    } catch (e) {
      throw InvalidConfigFileException(
        message: 'Error reading $configFileName: $e',
      );
    }
  }

  /// Checks whether the config file exists.
  static bool configExists() {
    return File(configFileName).existsSync();
  }
}
