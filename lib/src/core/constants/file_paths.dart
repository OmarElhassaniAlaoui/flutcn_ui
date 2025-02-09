import 'dart:io';

import 'package:path/path.dart' as path;

class FilePaths {
  FilePaths._();

  static const String widgetPath = 'lib/widgets'; // Or make this configurable
  static const String themePath = 'lib/themes'; // Or make this configurable
  // Use path.join
  static final String defaultThemePath =
      File(path.join('lib/src/core/constants/default_theme.dart')).readAsStringSync();
  static final String zincThemeFileContent =
      File(path.join('lib/src/core/constants/zinc_palette_colors.txt')).readAsStringSync();
  static final String newYorkThemeFileContent =
      File(path.join('lib/src/core/constants/new_york_theme.txt')).readAsStringSync();

  static final String slateThemeFileContent =
      File(path.join('lib/src/core/constants/slate_palette_colors.txt')).readAsStringSync();
  static final String grayThemeFileContent =
      File(path.join('lib/src/core/constants/gray_palette_colors.txt')).readAsStringSync();
}
