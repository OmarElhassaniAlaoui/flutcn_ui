import 'dart:async';

/// Stub for non-web platforms — no-op implementation.
StreamSubscription<dynamic>? listenForThemeChanges(void Function(String theme) onThemeChange) {
  return null;
}
