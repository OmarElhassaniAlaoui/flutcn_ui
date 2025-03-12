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
    _spinner?.stop();
    print('\x1B[32m \u{2714} \x1B[0m $message');
  }

  /// Stops the spinner and displays an error message
  void error(String message) {
    _spinner?.stop();
    print('\x1B[31m \u{274C} \x1B[0m $message');
  } 

  

  /// Runs an asynchronous action with a spinner
  Future<void> runWithSpinner({
    required String message,
    required Future<void> Function() action,
    String? onFinish,
  }) async {
    start(message);
    try {
      await action();
      success(message);
      if (onFinish != null) {
        success(onFinish);
      }
    } catch (e) {
      error('$message: $e');
      rethrow;
    }
  }
}
