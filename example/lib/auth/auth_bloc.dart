import 'dart:async';

import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_repository_interface.dart';
import 'auth_result.dart';
import 'auth_state.dart';

//void printError(String text) => print('\x1B[31m$text\x1B[0m');
void printError(String text) => {};

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc(IAuthRepository authRepository)
      : _authRepository = authRepository,
        super(AuthLoggedOut()) {
    on<AuthAttempt>(_onAuthAttempt);
    on<AuthLogout>(_onAuthLoggedOut);
  }

  FutureOr<void> _onAuthAttempt(
      AuthAttempt event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    AuthResult _result = await _authRepository.signIn(event.credentials);
    switch (_result) {
      case AuthResult.success:
        emit(AuthLoggedIn());
        break;
      case AuthResult.insufficientPermissions:
        printError(
            '###### AUTH RESULT: $_result for ${event.credentials.email}:${event.credentials.password}');
        emit(AuthInsufficientPermissions());
        break;
      case AuthResult.disabled:
        printError(
            '###### AUTH RESULT: $_result for ${event.credentials.email}:${event.credentials.password}');
        emit(AuthDisabled());
        break;
      case AuthResult.error:
      default:
        printError(
            '###### AUTH RESULT: $_result for ${event.credentials.email}:${event.credentials.password}');
        emit(AuthInvalidCredentials());
        break;
    }
  }

  FutureOr<void> _onAuthLoggedOut(
      AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoggedOut());
  }
}
