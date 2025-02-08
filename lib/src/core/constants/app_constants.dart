class AppConstants {
  AppConstants._();
  static const String baseUrl = 'https://flatcn.com/api/v1';

  static const String widgetPath = 'lib/widgets';
  static const String themePath = 'lib/themes';
  static const String stylePath = 'lib/themes/style.dart';
  static const String defaultThemePath = 'lib/themes/default_theme.dart';
  static const String defaultStylePath = 'lib/themes/style.dart';

  static const String zincThemeFileContent = '''
    import 'package:flutter/material.dart';
  class AppThemes {
  AppThemes._();

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppPalette.darkPrimarySwatch,
    scaffoldBackgroundColor: AppPalette.darkBackground,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.darkPrimarySwatch,
      onPrimary: AppPalette.darkPrimaryForeground,
      secondary: AppPalette.darkSecondary,
      onSecondary: AppPalette.darkSecondaryForeground,
      error: AppPalette.destructiveColor,
      onError: AppPalette.destructiveForeground,
      background: AppPalette.darkBackground,
      onBackground: AppPalette.darkForeground,
      surface: AppPalette.darkBackground,
      onSurface: AppPalette.darkForeground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.darkBackground,
      foregroundColor: AppPalette.darkForeground,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: AppPalette.darkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppPalette.darkInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppPalette.darkBorder,
        ),
      ),
    ),
    extensions: [
      ChartColors(
        chart1: AppPalette.darkChartColor1,
        chart2: AppPalette.darkChartColor2,
        chart3: AppPalette.darkChartColor3,
        chart4: AppPalette.darkChartColor4,
        chart5: AppPalette.darkChartColor5,
      ),
    ],
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    primaryColor: AppPalette.primarySwatch,
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.primarySwatch,
      onPrimary: AppPalette.primaryForeground,
      secondary: AppPalette.secondaryColor,
      onSecondary: AppPalette.secondaryForeground,
      error: AppPalette.destructiveColor,
      onError: AppPalette.destructiveForeground,
      background: AppPalette.backgroundColor,
      onBackground: AppPalette.foregroundColor,
      surface: AppPalette.backgroundColor,
      onSurface: AppPalette.foregroundColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.backgroundColor,
      foregroundColor: AppPalette.foregroundColor,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: AppPalette.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppPalette.inputColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppPalette.borderColor,
        ),
      ),
    ),
    extensions: [
      ChartColors(
        chart1: AppPalette.chartColor1,
        chart2: AppPalette.chartColor2,
        chart3: AppPalette.chartColor3,
        chart4: AppPalette.chartColor4,
        chart5: AppPalette.chartColor5,
      ),
    ],
  );
}

// Custom theme extension for chart colors
class ChartColors extends ThemeExtension<ChartColors> {
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  ChartColors({
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  @override
  ThemeExtension<ChartColors> copyWith({
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return ChartColors(
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  @override
  ThemeExtension<ChartColors> lerp(ThemeExtension<ChartColors>? other, double t) {
    if (other is! ChartColors) {
      return this;
    }
    return ChartColors(
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
    );
  }
}
  
  
   ''';
  static const String appPalette = '''
          import 'package:flutter/material.dart';

          class AppPalette {
            AppPalette._();

            // Light theme colors
            static const backgroundColor = Color(0xFFFFFFFF); // --background
            static const foregroundColor = Color(0xFF09090B); // --foreground
            static const primarySwatch = Color(0xFF18181B); // --primary
            static const primaryForeground = Color(0xFFFAFAFA); // --primary-foreground
            static const secondaryColor = Color(0xFFF4F4F5); // --secondary
            static const secondaryForeground = Color(0xFF18181B); // --secondary-foreground
            static const mutedColor = Color(0xFFF4F4F5); // --muted
            static const mutedForeground = Color(0xFF71717A); // --muted-foreground
            static const destructiveColor = Color(0xFFEF4444); // --destructive
            static const destructiveForeground = Color(0xFFFAFAFA); // --destructive-foreground
            static const borderColor = Color(0xFFE4E4E7); // --border
            static const inputColor = Color(0xFFE4E4E7); // --input
            
            // Dark theme colors
            static const darkBackground = Color(0xFF09090B); // --background
            static const darkForeground = Color(0xFFFAFAFA); // --foreground
            static const darkPrimarySwatch = Color(0xFFFAFAFA); // --primary
            static const darkPrimaryForeground = Color(0xFF18181B); // --primary-foreground
            static const darkSecondary = Color(0xFF27272A); // --secondary
            static const darkSecondaryForeground = Color(0xFFFAFAFA); // --secondary-foreground
            static const darkMuted = Color(0xFF27272A); // --muted
            static const darkMutedForeground = Color(0xFFA1A1AA); // --muted-foreground
            static const darkBorder = Color(0xFF27272A); // --border
            static const darkInput = Color(0xFF27272A); // --input

            // Chart colors - Light
            static const chartColor1 = Color(0xFFE86C3A); // --chart-1
            static const chartColor2 = Color(0xFF2E8B99); // --chart-2
            static const chartColor3 = Color(0xFF23424D); // --chart-3
            static const chartColor4 = Color(0xFFD6AB23); // --chart-4
            static const chartColor5 = Color(0xFFE6752E); // --chart-5

            // Chart colors - Dark
            static const darkChartColor1 = Color(0xFF3B82F6); // --chart-1
            static const darkChartColor2 = Color(0xFF34D399); // --chart-2
            static const darkChartColor3 = Color(0xFFFCD34D); // --chart-3
            static const darkChartColor4 = Color(0xFFD946EF); // --chart-4
            static const darkChartColor5 = Color(0xFFF43F5E); // --chart-5
          }
  
   ''';

  static const String SlateThemeFileContent = ''' ''';
  static const String GrayThemeFileContent = ''' ''';
}
