class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  @override
  String toString() => 'ServerException: $message';
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class ComponentNotFoundException implements Exception {
  final String message;

  ComponentNotFoundException({required this.message});

  @override
  String toString() => 'ComponentNotFoundException: $message';
}

class ThemeNotFoundException implements Exception {
  final String message;

  ThemeNotFoundException({required this.message});

  @override
  String toString() => 'ThemeNotFoundException: $message';
}

class DependencyNotFoundException implements Exception {
  final String message;

  DependencyNotFoundException({required this.message});

  @override
  String toString() => 'DependencyNotFoundException: $message';
}

class CircularDependencyException implements Exception {
  final String message;

  CircularDependencyException({required this.message});

  @override
  String toString() => 'CircularDependencyException: $message';
}

class InvalidConfigFileException implements Exception {
  final String message;

  InvalidConfigFileException({required this.message});

  @override
  String toString() => 'InvalidConfigFileException: $message';
}

class InvalidComponentFileException implements Exception {
  final String message;

  InvalidComponentFileException({required this.message});

  @override
  String toString() => 'InvalidComponentFileException: $message';
}

class InitializationException implements Exception {
  final String message;
  InitializationException([this.message = 'Failed to initialize project']);
}
// Add more exceptions as needed for other operations (e.g., file system errors, JSON parsing errors)
