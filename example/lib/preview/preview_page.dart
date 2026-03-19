import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'preview_registry.dart';
import 'web_interop_stub.dart' if (dart.library.html) 'web_interop_web.dart';

class PreviewPage extends StatefulWidget {
  final String widgetName;
  final String? theme;

  const PreviewPage({
    super.key,
    required this.widgetName,
    this.theme,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  StreamSubscription<dynamic>? _messageSubscription;

  @override
  void initState() {
    super.initState();

    // Set initial theme from URL param
    if (widget.theme == 'dark') {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }

    // Listen for postMessage from parent iframe (web only)
    if (kIsWeb) {
      _messageSubscription = listenForThemeChanges((theme) {
        themeNotifier.value =
            theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final builder = previewRegistry[widget.widgetName];

    if (builder == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Text(
            'Widget "${widget.widgetName}" not found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: builder(),
      ),
    );
  }
}
