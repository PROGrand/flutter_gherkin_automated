import '../users/users_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_credentials.dart';
import 'auth_repository_interface.dart';
import 'auth_result.dart';

//void printError(String text) => print('\x1B[31m$text\x1B[0m');
void printError(String text) => {};

class AuthRepository implements IAuthRepository {
  static const TAG = "AuthRepository";

  final FirebaseAuth _firebaseAuth;

  AuthRepository(
      {required FirebaseAuth firebaseAuth,
      required IUsersRepository usersRepository})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<AuthResult> signIn(AuthCredentials credentials) async {
    AuthResult _result = AuthResult.error;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: credentials.email, password: credentials.password);
      _result = AuthResult.success;
    } on FirebaseAuthException catch (e) {
      printError(
          "$TAG: Sign in failed with Firebase Auth error: ${e.code}, ${e.message}");
      _result = AuthResult.error;
    } catch (e) {
      printError("$TAG: Sign in failed: ${e.runtimeType}");
      _result = AuthResult.error;
    }
    return _result;
  }
}
