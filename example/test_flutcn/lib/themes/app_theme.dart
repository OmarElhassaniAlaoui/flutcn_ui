import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './app_pallete.dart';
// Enum for all available color schemes


class FlutcnTheme {
  // Default border radius values
  static const double _radiusSmall = 4.0;
  static const double _radiusDefault = 8.0;
  static const double _radiusLarge = 12.0;
  static const double _radiusXL = 16.0;

  // Animation duration
  static const Duration _animationDuration = Duration(milliseconds: 200);
  static final colorScheme = AppPalette.colors;
  

  // Create light theme
  static ThemeData lightTheme() {
    final colors = colorScheme;
    final primary = colors['primary']!;
    final onPrimary = colors['primaryForeground']!;
    final secondary = colors['secondary']!;
    final onSecondary = colors['secondaryForeground']!;
    final background = colors['background']!;
    final onBackground = colors['foreground']!;
    final surface = background;
    final onSurface = onBackground;
    final error = colors['destructive']!;
    final onError = colors['destructiveForeground']!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(64, 40),
          side: BorderSide(color: colors['border']!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors['input']!,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['border']!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['border']!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['ring']!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: error, width: 2),
        ),
      ),
      cardTheme: CardTheme(
        color: background,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge),
          side: BorderSide(color: colors['border']!),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['input']!;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSmall),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['input']!;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['muted']!;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.5);
          }
          return colors['input']!;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: colors['muted']!,
        circularTrackColor: colors['muted']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge),
        ),
        elevation: 4,
      ),
      dividerTheme: DividerThemeData(
        color: colors['border']!,
        thickness: 1,
        space: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onBackground,
        contentTextStyle: TextStyle(color: background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: onBackground,
          borderRadius: BorderRadius.circular(_radiusSmall),
        ),
        textStyle: TextStyle(color: background),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: primary.withOpacity(0.05),
      focusColor: primary.withOpacity(0.1),
      splashFactory: NoSplash.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  // Create dark theme
  static ThemeData darkTheme() {
    final colors = colorScheme;
    final primary = colors['primaryForeground']!;
    final onPrimary = colors['primary']!;
    final secondary = colors['darkMuted']!;
    final onSecondary = colors['darkForeground']!;
    final background = colors['darkBackground']!;
    final onBackground = colors['darkForeground']!;
    final surface = background;
    final onSurface = onBackground;
    final error = colors['destructive']!;
    final onError = colors['destructiveForeground']!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onBackground,
          minimumSize: const Size(64, 40),
          side: BorderSide(color: colors['darkBorder']!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: onBackground,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusDefault),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors['darkMuted']!,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['darkBorder']!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['darkBorder']!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: colors['darkMutedForeground']!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
          borderSide: BorderSide(color: error, width: 2),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['darkMuted']!,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge),
          side: BorderSide(color: colors['darkBorder']!),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['darkMuted']!;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSmall),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['darkMuted']!;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return colors['darkMuted']!;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.5);
          }
          return colors['darkMuted']!;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: colors['darkMuted']!,
        circularTrackColor: colors['darkMuted']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge),
        ),
        elevation: 4,
      ),
      dividerTheme: DividerThemeData(
        color: colors['darkBorder']!,
        thickness: 1,
        space: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onBackground,
        contentTextStyle: TextStyle(color: background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusDefault),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: onBackground,
          borderRadius: BorderRadius.circular(_radiusSmall),
        ),
        textStyle: TextStyle(color: background),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: onBackground.withOpacity(0.05),
      focusColor: onBackground.withOpacity(0.1),
      splashFactory: NoSplash.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}