import 'package:cli_spin/cli_spin.dart';

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
      error('$onError: $e');
      rethrow;
    }
  }
}
