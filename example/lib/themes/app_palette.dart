import 'package:flutter/material.dart';

/// Typed, immutable token model for a single FlutCN color scheme.
/// Mirrors shadcn/ui's CSS variable set exactly — one field per token.
@immutable
class FlutcnColorTokens {
  // Surfaces
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;

  // Brand
  final Color primary;
  final Color primaryForeground;

  // Secondary
  final Color secondary;
  final Color secondaryForeground;

  // Muted / subdued
  final Color muted;
  final Color mutedForeground;

  // Accent / hover
  final Color accent;
  final Color accentForeground;

  // Destructive
  final Color destructive;
  final Color destructiveForeground;

  // Structural
  final Color border;

  /// --input in shadcn is the BORDER color of form inputs, not the fill.
  final Color input;

  /// Focus ring color.
  final Color ring;

  /// Global corner radius (--radius). Use radius-2 for inner, radius+4 for lg.
  final double radius;

  const FlutcnColorTokens({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    this.radius = 8.0,
  });

  // ── Zinc light ──────────────────────────────────────────────────────────────
  static const light = FlutcnColorTokens(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF09090B), // zinc-950
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF09090B),
    primary: Color(0xFF18181B), // zinc-900
    primaryForeground: Color(0xFFFAFAFA), // zinc-50
    secondary: Color(0xFFF4F4F5), // zinc-100
    secondaryForeground: Color(0xFF18181B),
    muted: Color(0xFFF4F4F5), // zinc-100
    mutedForeground: Color(0xFF71717A), // zinc-500
    accent: Color(0xFFF4F4F5), // zinc-100
    accentForeground: Color(0xFF18181B),
    destructive: Color(0xFFEF4444), // red-500
    destructiveForeground: Color(0xFFFAFAFA),
    border: Color(0xFFE4E4E7), // zinc-200
    input: Color(0xFFE4E4E7), // zinc-200 — input border color
    ring: Color(0xFF18181B), // zinc-900
    radius: 8.0,
  );

  // ── Zinc dark ───────────────────────────────────────────────────────────────
  static const dark = FlutcnColorTokens(
    background: Color(0xFF09090B), // zinc-950
    foreground: Color(0xFFFAFAFA), // zinc-50
    card: Color(0xFF09090B),
    cardForeground: Color(0xFFFAFAFA),
    primary: Color(0xFFFAFAFA), // zinc-50
    primaryForeground: Color(0xFF18181B), // zinc-900
    secondary: Color(0xFF27272A), // zinc-800
    secondaryForeground: Color(0xFFFAFAFA),
    muted: Color(0xFF27272A), // zinc-800
    mutedForeground: Color(0xFFA1A1AA), // zinc-400
    accent: Color(0xFF27272A), // zinc-800
    accentForeground: Color(0xFFFAFAFA),
    destructive: Color(0xFF7F1D1D), // hsl(0, 62.8%, 30.6%) — dark destructive
    destructiveForeground: Color(0xFFFAFAFA),
    border: Color(0xFF27272A), // zinc-800
    input: Color(0xFF27272A), // zinc-800 — input border color
    ring: Color(0xFFD4D4D8), // zinc-300
    radius: 8.0,
  );
}
