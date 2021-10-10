import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthLoggedOut extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthInvalidCredentials extends AuthError {
  AuthInvalidCredentials()
      : super(
            "Email and/or password is invalid. Please try again or contact support.");
}

class AuthInsufficientPermissions extends AuthError {
  AuthInsufficientPermissions()
      : super("You do not have permission to access this tool.");
}

class AuthDisabled extends AuthError {
  AuthDisabled()
      : super(
            "Email and/or password is invalid. Please try again or contact support.");
}

class AuthLoggedIn extends AuthState {
  @override
  List<Object> get props => [];
}
