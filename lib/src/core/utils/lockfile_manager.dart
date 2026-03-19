import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';

/// Manages the `flutcn.lock.json` file that tracks installed widgets
/// and their content hashes for change detection.
class LockfileManager {
  static const String lockfileName = 'flutcn.lock.json';

  /// Reads and parses the lockfile. Returns empty structure if file doesn't exist.
  static Map<String, dynamic> readLockfile() {
    final file = File(lockfileName);

    if (!file.existsSync()) {
      return {'lockfileVersion': 1, 'widgets': <String, dynamic>{}};
    }

    try {
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      // Ensure widgets map exists
      json['widgets'] ??= <String, dynamic>{};
      return json;
    } on FormatException catch (e) {
      throw InvalidConfigFileException(
        message: 'Invalid JSON in $lockfileName: ${e.message}',
      );
    }
  }

  /// Writes the lockfile as pretty-printed JSON.
  static void writeLockfile(Map<String, dynamic> lockfile) {
    final file = File(lockfileName);
    final encoder = const JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(lockfile));
  }

  /// Computes SHA-256 hash of content, prefixed with "sha256:".
  static String computeHash(String content) {
    final bytes = utf8.encode(content);
    final digest = sha256.convert(bytes);
    return 'sha256:$digest';
  }

  /// Records a widget in the lockfile (add or update).
  static void recordWidget(String name, String style, String content) {
    final lockfile = readLockfile();
    final widgets = lockfile['widgets'] as Map<String, dynamic>;

    widgets[name] = {
      'style': style,
      'contentHash': computeHash(content),
      'installedAt': DateTime.now().toUtc().toIso8601String(),
    };

    writeLockfile(lockfile);
  }

  /// Removes a widget entry from the lockfile.
  static void removeWidget(String name) {
    final lockfile = readLockfile();
    final widgets = lockfile['widgets'] as Map<String, dynamic>;
    widgets.remove(name);
    writeLockfile(lockfile);
  }

  /// Returns the widget entry from the lockfile, or null if not tracked.
  static Map<String, dynamic>? getWidget(String name) {
    final lockfile = readLockfile();
    final widgets = lockfile['widgets'] as Map<String, dynamic>;
    final entry = widgets[name];
    return entry != null ? entry as Map<String, dynamic> : null;
  }

  /// Checks if a widget's content matches the lockfile hash.
  /// Returns true if hashes match, false if different or not tracked.
  static bool isUpToDate(String name, String content) {
    final entry = getWidget(name);
    if (entry == null) return false;
    return entry['contentHash'] == computeHash(content);
  }

  /// Checks whether the lockfile exists on disk.
  static bool lockfileExists() {
    return File(lockfileName).existsSync();
  }
}
