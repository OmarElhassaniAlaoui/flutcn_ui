import 'package:web/web.dart' as web;

/// Web implementation — reads the full browser URL.
Uri? getBrowserUri() {
  return Uri.parse(web.window.location.href);
}
