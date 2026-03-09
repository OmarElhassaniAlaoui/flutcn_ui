import 'package:flutter/material.dart';
import './app_palette.dart';

// ── FlutcnTokensTheme ────────────────────────────────────────────────────────
// InheritedWidget that carries the full shadcn token set down the widget tree.
// Tokens with no M3 ColorScheme slot (muted, ring, radius, accent, card …)
// are readable here at build time.
//
// Usage:
//   final tokens = FlutcnTokensTheme.of(context);
//   color: tokens.mutedForeground
// ─────────────────────────────────────────────────────────────────────────────

class FlutcnTokensTheme extends InheritedWidget {
  final FlutcnColorTokens tokens;

  const FlutcnTokensTheme({
    super.key,
    required this.tokens,
    required super.child,
  });

  static FlutcnColorTokens of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<FlutcnTokensTheme>();
    assert(result != null,
        'No FlutcnTokensTheme found. Wrap your app with FlutcnTokensTheme.');
    return result!.tokens;
  }

  /// Returns null when FlutcnTokensTheme is not in the tree.
  static FlutcnColorTokens? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FlutcnTokensTheme>()
        ?.tokens;
  }

  @override
  bool updateShouldNotify(FlutcnTokensTheme old) => tokens != old.tokens;
}

// ── FlutcnTheme ───────────────────────────────────────────────────────────────
// Builds Material ThemeData from typed FlutcnColorTokens.
// Public API (lightTheme / darkTheme) is unchanged so main.dart needs no edit.
// ─────────────────────────────────────────────────────────────────────────────

class FlutcnTheme {
  FlutcnTheme._();

  static ThemeData lightTheme() => _buildTheme(FlutcnColorTokens.light);
  static ThemeData darkTheme() => _buildTheme(FlutcnColorTokens.dark);

  static ThemeData _buildTheme(FlutcnColorTokens t) {
    final isDark = t.background.computeLuminance() < 0.5;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final textTheme = _buildTextTheme(t);

    final colorScheme = ColorScheme(
      brightness: brightness,
      // Primary
      primary: t.primary,
      onPrimary: t.primaryForeground,
      primaryContainer: t.primary,
      onPrimaryContainer: t.primaryForeground,
      // Secondary
      secondary: t.secondary,
      onSecondary: t.secondaryForeground,
      secondaryContainer: t.secondary,
      onSecondaryContainer: t.secondaryForeground,
      // Tertiary → accent (closest M3 slot)
      tertiary: t.accent,
      onTertiary: t.accentForeground,
      tertiaryContainer: t.accent,
      onTertiaryContainer: t.accentForeground,
      // Error → destructive
      error: t.destructive,
      onError: t.destructiveForeground,
      errorContainer: t.destructive,
      onErrorContainer: t.destructiveForeground,
      // Surfaces
      surface: t.background,
      onSurface: t.foreground,
      surfaceContainerHighest: t.card,
      onSurfaceVariant: t.mutedForeground,
      // Outline — explicitly mapped to shadcn tokens (not auto-generated)
      outline: t.input,         // --input  : form input border
      outlineVariant: t.border, // --border : card / divider border
      // Misc
      scrim: Colors.black,
      shadow: Colors.black,
      inverseSurface: t.foreground,
      onInverseSurface: t.background,
      inversePrimary: t.primaryForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: t.background,
      textTheme: textTheme,

      // ── Buttons ────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: t.primaryForeground,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radius),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.foreground,
          minimumSize: const Size(64, 40),
          side: BorderSide(color: t.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.foreground,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────────
      // FIX: fillColor = background (white/zinc-950), NOT t.input.
      // t.input is the BORDER color (--input = zinc-200/zinc-800).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: textTheme.bodyMedium?.copyWith(color: t.mutedForeground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.input),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.destructive, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radius),
          borderSide: BorderSide(color: t.input.withValues(alpha: 0.4)),
        ),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: t.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radius + 4),
          side: BorderSide(color: t.border),
        ),
      ),

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: t.background,
        foregroundColor: t.foreground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: t.foreground),
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: t.border,
        thickness: 1,
        space: 24,
      ),

      // ── Dialog ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: t.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radius + 4),
        ),
        elevation: 4,
      ),

      // ── Checkbox / Radio / Switch ──────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.muted;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radius - 4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.muted;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return t.primaryForeground;
          }
          return t.mutedForeground;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.muted;
        }),
      ),

      // ── Progress ───────────────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.primary,
        linearTrackColor: t.muted,
        circularTrackColor: t.muted,
      ),

      // ── SnackBar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.foreground,
        contentTextStyle: TextStyle(color: t.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radius),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Tooltip ────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.foreground,
          borderRadius: BorderRadius.circular(t.radius - 4),
        ),
        textStyle: TextStyle(color: t.background),
      ),

      // ── Interaction ────────────────────────────────────────────────────────
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: t.accent.withValues(alpha: 0.8),
      focusColor: t.ring.withValues(alpha: 0.1),
      splashFactory: NoSplash.splashFactory,

      // ── Transitions ────────────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  // ── Typography ──────────────────────────────────────────────────────────────
  // Matches shadcn/ui's type scale:
  //   text-xs  (12px) → bodySmall / labelSmall
  //   text-sm  (14px) → bodyMedium / labelLarge  ← default body text
  //   text-base(16px) → bodyLarge / titleMedium
  //   text-lg  (18px) → titleLarge
  //   text-2xl (24px) → headlineSmall
  //   text-3xl (30px) → headlineMedium
  //   text-4xl (36px) → headlineLarge / displaySmall
  // ───────────────────────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(FlutcnColorTokens t) {
    final fg = t.foreground;
    final muted = t.mutedForeground;

    return TextTheme(
      // Body
      bodySmall: TextStyle(
          fontSize: 12, height: 1.5, color: muted, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.43,
          color: fg,
          fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          fontSize: 16, height: 1.5, color: fg, fontWeight: FontWeight.w400),
      // Label
      labelSmall: TextStyle(
          fontSize: 11,
          height: 1.45,
          color: muted,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5),
      labelMedium: TextStyle(
          fontSize: 12, height: 1.5, color: muted, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(
          fontSize: 14,
          height: 1.43,
          color: fg,
          fontWeight: FontWeight.w500),
      // Title
      titleSmall: TextStyle(
          fontSize: 14,
          height: 1.43,
          color: fg,
          fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
          fontSize: 16, height: 1.5, color: fg, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(
          fontSize: 18, height: 1.4, color: fg, fontWeight: FontWeight.w600),
      // Headline
      headlineSmall: TextStyle(
          fontSize: 24,
          height: 1.33,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5),
      headlineMedium: TextStyle(
          fontSize: 30,
          height: 1.27,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5),
      headlineLarge: TextStyle(
          fontSize: 36,
          height: 1.22,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5),
      // Display
      displaySmall: TextStyle(
          fontSize: 36,
          height: 1.22,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.75),
      displayMedium: TextStyle(
          fontSize: 45,
          height: 1.16,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0),
      displayLarge: TextStyle(
          fontSize: 57,
          height: 1.12,
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5),
    );
  }
}
