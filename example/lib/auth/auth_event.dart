import 'package:meta/meta.dart';

import 'auth_credentials.dart';

@immutable
abstract class AuthEvent {}

class AuthAttempt extends AuthEvent {
  final AuthCredentials credentials;

  AuthAttempt(this.credentials);
}

class AuthLoginSuccess extends AuthEvent {}

class AuthLogout extends AuthEvent {}
