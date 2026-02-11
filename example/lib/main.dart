import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'home.dart';
import 'theme_notifier.dart';

final themeNotifier = ThemeNotifier();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Flutcn UI Showcase',
          debugShowCheckedModeBanner: false,
          theme: FlutcnTheme.lightTheme(),
          darkTheme: FlutcnTheme.darkTheme(),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
