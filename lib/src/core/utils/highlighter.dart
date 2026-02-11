extension Highlighter on String {
  String highlight(String color) {
    const String reset = '\x1B[0m';
    return '$color$this$reset';
  }
}
