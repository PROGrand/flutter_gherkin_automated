import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/example_model.dart';

import 'user_entity.dart';
import 'users_repository_interface.dart';

class UserNotFoundException implements Exception {}

class UserMissingRoleException implements Exception {}

class UsersRepository implements IUsersRepository {
  final CollectionReference<Map<String, dynamic>> _usersCollection;

  UsersRepository(FirebaseFirestore firestore)
      : _usersCollection = firestore.collection('${ExampleModel.users}');

  Stream<List<User>> users() {
    return _usersCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return User(
                id: doc.id,
                name: doc.get(ExampleModel.users.name),
              );
            }).toList(growable: false));
  }

  @override
  Future addNewUser(String userId, User user) async =>
      _usersCollection.doc(userId).set({
        ExampleModel.users.name: user.name,
      });
}
