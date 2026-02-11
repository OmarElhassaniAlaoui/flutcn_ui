import 'dart:io';

class MultiCheckboxListChooser {
  final List<String> options;
  final Set<int> selectedIndices = {};
  int _selectedIndex = 0;
  final bool _isWindows = Platform.isWindows;

  MultiCheckboxListChooser({required this.options});

  Set<String> choose() {
    _setupConsole();
    _renderList();

    while (true) {
      final input = _getInput();
      if (input == -1) continue;

      if (input == 10) {
        // Enter key
        _cleanupConsole();
        return selectedIndices.map((index) => options[index]).toSet();
      }

      if (input == 32) {
        // Space bar
        _toggleSelection();
      } else if (input == _upArrow) {
        _selectedIndex = (_selectedIndex - 1).clamp(0, options.length - 1);
      } else if (input == _downArrow) {
        _selectedIndex = (_selectedIndex + 1).clamp(0, options.length - 1);
      }

      _renderList();
    }
  }

  void _toggleSelection() {
    if (selectedIndices.contains(_selectedIndex)) {
      selectedIndices.remove(_selectedIndex);
    } else {
      selectedIndices.add(_selectedIndex);
    }
  }

  void _renderList() {
    final buffer = StringBuffer();
    for (var i = 0; i < options.length; i++) {
      final isSelected = selectedIndices.contains(i);
      final isCurrent = i == _selectedIndex;

      // Checkbox with green color for selected items
      final checkbox = isSelected ? '\x1B[32m[•]\x1B[0m' : '[ ]';

      // Text with cyan color for current item
      final text = isCurrent ? '\x1B[36m${options[i]}\x1B[0m' : options[i];

      buffer.writeln('$checkbox $text');
    }
    _moveCursorUp(options.length);
    stdout.write(buffer.toString());
  }

  void _moveCursorUp(int lines) => stdout.write('\x1B[${lines}A');
  int get _upArrow => _isWindows ? 72 : 65;
  int get _downArrow => _isWindows ? 80 : 66;

  void _setupConsole() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    stdout.writeln('\n' * options.length); // Create space for the list
  }

  void _cleanupConsole() {
    stdin.echoMode = true;
    stdin.lineMode = true;
  }

  int _getInput() {
    final input = stdin.readByteSync();
    if (_isWindows) return input;

    // Handle Linux/Mac arrow keys (3-byte sequence)
    if (input == 27) {
      if (stdin.readByteSync() == 91) {
        return stdin.readByteSync();
      }
    }
    return input;
  }
}
