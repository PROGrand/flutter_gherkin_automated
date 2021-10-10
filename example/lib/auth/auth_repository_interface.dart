import 'auth_result.dart';
import 'auth_credentials.dart';

abstract class IAuthRepository {
  Future<AuthResult> signIn(AuthCredentials credentials);
}
