import 'package:cli_spin/cli_spin.dart';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';

class SpinnerHelper {

  CliSpin? _spinner;

  /// Starts a spinner with a given message
  void start(String message) {
    _spinner = CliSpin(
      text: message,
      spinner: CliSpinners.dots,
      color: CliSpinnerColor.green,
    )..start();
  }

  /// Stops the spinner and displays a success message
  void success(String message) {
    _spinner?.success(message);
  }

  /// Stops the spinner and displays an error message
  void error(String message) {
    _spinner?.fail(message);
  }

  /// Runs an asynchronous action with a spinner
  Future<void> runWithSpinner({
    required String message,
    required Future<void> Function() action,
    String? onSuccess,
    String? onError,
  }) async {
    start(message);
    try {
      await action();
      success(onSuccess ?? message);
    } catch (e) {
      error('$onError: ${_friendlyMessage(e)}');
      rethrow;
    }
  }

  String _friendlyMessage(Object e) {
    if (e is OfflineException) {
      return 'No internet connection. Check your network and try again.';
    } else if (e is ServerException) {
      return e.message;
    } else if (e is ComponentNotFoundException) {
      return e.message;
    } else if (e is ThemeNotFoundException) {
      return e.message;
    } else if (e is InvalidConfigFileException) {
      return e.message;
    } else if (e is InitializationException) {
      return e.message;
    }
    return e.toString();
  }
}
