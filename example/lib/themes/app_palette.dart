import 'package:flutter/material.dart';
class AppPalette {
  AppPalette._();

  static const Map<String, Color> colors = {
    'primary': Color(0xFF18181B), // zinc-900
    'primaryForeground': Color(0xFFFAFAFA), // zinc-50
    'secondary': Color(0xFFF4F4F5), // zinc-100
    'secondaryForeground': Color(0xFF18181B), // zinc-900
    'muted': Color(0xFFE4E4E7), // zinc-200
    'mutedForeground': Color(0xFF71717A), // zinc-500
    'accent': Color(0xFFF4F4F5), // zinc-100
    'accentForeground': Color(0xFF18181B), // zinc-900
    'destructive': Color(0xFFEF4444), // red-500
    'destructiveForeground': Color(0xFFFAFAFA), // zinc-50
    'border': Color(0xFFE4E4E7), // zinc-200
    'input': Color(0xFFE4E4E7), // zinc-200
    'ring': Color(0xFFA1A1AA), // zinc-400
    'background': Color(0xFFFFFFFF), // white
    'foreground': Color(0xFF18181B), // zinc-900
    'darkBackground': Color(0xFF09090B), // zinc-950
    'darkForeground': Color(0xFFFAFAFA), // zinc-50
    'darkMuted': Color(0xFF27272A), // zinc-800
    'darkMutedForeground': Color(0xFFA1A1AA), // zinc-400
    'darkBorder': Color(0xFF3F3F46), // zinc-700
  };
}