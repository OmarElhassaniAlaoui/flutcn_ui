import 'package:flutter/material.dart';
import '../main.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        final isDark = themeMode == ThemeMode.dark;

        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: child,
              );
            },
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey<bool>(isDark),
            ),
          ),
          onPressed: () => themeNotifier.toggleTheme(),
          tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
        );
      },
    );
  }
}
