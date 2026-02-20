import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'home.dart';
import 'theme_notifier.dart';
import 'preview/preview_page.dart';
import 'preview/url_reader_stub.dart'
    if (dart.library.js_interop) 'preview/url_reader_web.dart';

final themeNotifier = ThemeNotifier();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Read the browser URL to determine if we're in preview mode
  String? previewWidget;
  String? previewTheme;

  final browserUri = getBrowserUri();
  if (browserUri != null) {
    previewWidget = browserUri.queryParameters['widget'];
    previewTheme = browserUri.queryParameters['theme'];
  }

  runApp(MyApp(previewWidget: previewWidget, previewTheme: previewTheme));
}

class MyApp extends StatelessWidget {
  final String? previewWidget;
  final String? previewTheme;

  const MyApp({super.key, this.previewWidget, this.previewTheme});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        final home = previewWidget != null
            ? PreviewPage(widgetName: previewWidget!, theme: previewTheme)
            : const HomePage();

        return MaterialApp(
          title: 'Flutcn UI Showcase',
          debugShowCheckedModeBanner: false,
          theme: FlutcnTheme.lightTheme(),
          darkTheme: FlutcnTheme.darkTheme(),
          themeMode: themeMode,
          home: home,
        );
      },
    );
  }
}
