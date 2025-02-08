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
  
  
   