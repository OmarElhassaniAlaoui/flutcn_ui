extension Highlighter on String {
  String highlight(String keyword, {String? color = '\x1B[34m'}) { 
    const String reset = '\x1B[0m'; 

    // Replace all occurrences of the keyword with the colored version
    return replaceAll(
      RegExp(keyword, caseSensitive: false), 
      '$color$keyword$reset'
    );
  }
}
