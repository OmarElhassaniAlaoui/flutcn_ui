import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message; // Add a message property

  Failure({required this.message}); // Constructor with message

  @override
  List<Object?> get props => [message]; // Include message in props
}

class OfflineFailure extends Failure {
  OfflineFailure({required super.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class ComponentNotFoundFailure extends Failure {
  ComponentNotFoundFailure({required super.message});
}

class ThemeNotFoundFailure extends Failure {
  ThemeNotFoundFailure({required super.message});
}

class DependencyNotFoundFailure extends Failure {
  DependencyNotFoundFailure({required super.message});
}

class CircularDependencyFailure extends Failure {
  CircularDependencyFailure({required super.message});
}

class InvalidConfigFileFailure extends Failure {
  InvalidConfigFileFailure({required super.message});
}

class InvalidComponentFileFailure extends Failure {
  InvalidComponentFileFailure({required super.message});
}

class GenericFailure extends Failure {
  GenericFailure({required super.message});
}
class InitializationFailure extends Failure {
  InitializationFailure() : super(message: 'Failed to initialize project');
}