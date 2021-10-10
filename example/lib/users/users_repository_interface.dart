import 'user_entity.dart';

abstract class IUsersRepository {
  Stream<List<User>> users();

  Future addNewUser(String userId, User user);
}
