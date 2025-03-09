import 'dart:io';

import 'package:path/path.dart' as path;

class FilePaths {
  FilePaths._();

  static const String widgetPath = 'lib/widgets'; // Or make this configurable
  static const String themePath = 'lib/themes'; // Or make this configurable
  // Use path.join
  static final String defaultThemePath =
      File(path.join('lib/src/core/registries/default_theme.dart'))
          .readAsStringSync();
  static final String zincThemeFileContent =
      File(path.join('lib/src/core/registries/zinc_palette_colors.txt'))
          .readAsStringSync();
  static final String newYorkThemeFileContent =
      File(path.join('lib/src/core/registries/new_york_theme.txt'))
          .readAsStringSync();

  static final String slateThemeFileContent =
      File(path.join('lib/src/core/registries/slate_palette_colors.txt'))
          .readAsStringSync();
  static final String grayThemeFileContent =
      File(path.join('lib/src/core/registries/gray_palette_colors.txt'))
          .readAsStringSync();
  static final String redThemeFileContent =
      File(path.join('lib/src/core/registries/red_palette_colors.txt'))
          .readAsStringSync();
  static final String roseThemeFileContent =
      File(path.join('lib/src/core/registries/rose_palette_colors.txt'))
          .readAsStringSync();
  static final String pinkThemeFileContent =
      File(path.join('lib/src/core/registries/pink_palette_colors.txt'))
          .readAsStringSync();
  static final String purpleThemeFileContent =
      File(path.join('lib/src/core/registries/purple_palette_colors.txt'))
          .readAsStringSync();
  static final String violetThemeFileContent =
      File(path.join('lib/src/core/registries/violet_palette_colors.txt'))
          .readAsStringSync();
  static final String indigoThemeFileContent =
      File(path.join('lib/src/core/registries/indigo_palette_colors.txt'))
          .readAsStringSync();
  static final String blueThemeFileContent =
      File(path.join('lib/src/core/registries/blue_palett_colors.txt'))
          .readAsStringSync();
  static final String skyThemeFileContent =
      File(path.join('lib/src/core/registries/sky_palette_colors.txt'))
          .readAsStringSync();
  static final String cyanThemeFileContent =
      File(path.join('lib/src/core/registries/cyan_palette_colors.txt'))
          .readAsStringSync();
  static final String tealThemeFileContent =
      File(path.join('lib/src/core/registries/teal_palette_colors.txt'))
          .readAsStringSync();
  static final String emeraldThemeFileContent =
      File(path.join('lib/src/core/registries/emerald_palette_colors.txt'))
          .readAsStringSync();
  static final String greenThemeFileContent =
      File(path.join('lib/src/core/registries/green_palette_colors.txt'))
          .readAsStringSync();
  static final String limeThemeFileContent =
      File(path.join('lib/src/core/registries/lime_palette_colors.txt'))
          .readAsStringSync();
  static final String yellowThemeFileContent =
      File(path.join('lib/src/core/registries/yellow_palette_colors.txt'))
          .readAsStringSync();
  static final String amberThemeFileContent =
      File(path.join('lib/src/core/registries/amber_palette_colors.txt'))
          .readAsStringSync();
  static final String orangeThemeFileContent =
      File(path.join('lib/src/core/registries/orange_palette_colors.txt'))
          .readAsStringSync();
  static final String brownThemeFileContent =
      File(path.join('lib/src/core/registries/brown_palette_colors.txt'))
          .readAsStringSync();
}
