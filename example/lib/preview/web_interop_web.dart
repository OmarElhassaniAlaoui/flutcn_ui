import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

extension type _ThemeMessage._(JSObject _) implements JSObject {
  external String? get type;
  external String? get theme;
}

/// Web implementation — listens for postMessage from parent iframe.
StreamSubscription<dynamic>? listenForThemeChanges(
    void Function(String theme) onThemeChange) {
  void handler(web.MessageEvent event) {
    final data = event.data;
    if (data.isA<JSObject>()) {
      final msg = data as _ThemeMessage;
      final type = msg.type;
      final theme = msg.theme;
      if (type == 'theme-change' && theme != null) {
        onThemeChange(theme);
      }
    }
  }

  final jsHandler = handler.toJS;
  web.window.addEventListener('message', jsHandler);

  final controller = StreamController<dynamic>(
    onCancel: () {
      web.window.removeEventListener('message', jsHandler);
    },
  );

  return controller.stream.listen((_) {});
}
