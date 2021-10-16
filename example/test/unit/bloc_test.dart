import 'package:example_with_automated_test/users/user_entity.dart';
import 'package:example_with_automated_test/users/users_events.dart';
import 'package:flutter_test/flutter_test.dart';

class MockUser extends UsersEvent {

}

void main() {
  group('bloc', () {
    group('user events', ()
    {
      test('UserEvent', () {
        final user = MockUser();
        expect(user.props is List<Object>, true);
        expect(user.props.length, 0);
      });

      test('AddUser', () {
        final user = User(id: 'id', name: 'addUser');
        final addUser = AddUser(user, email: 'email', password: 'password');
        expect(addUser.props is List<Object>, true);
        expect(addUser.props[0] is User, true);
        expect(addUser.props[1], 'email');
        expect(addUser.props[2], 'password');
        expect(addUser.props.length, 3);
        expect(addUser.toString(), 'AddUser { user: $user, email: ${'email'}, password: ${'password'.hashCode} }');
      });

      test('UserUpdated', () {
        final user = User(id: 'id', name: 'addUser');
        final list = [user];
        final addUser = UsersUpdated(list);
        expect(addUser.props is List<Object>, true);
        expect(addUser.props[0] is List<Object>, true);
        expect((addUser.props[0] as List<Object>).first, user);
        expect(addUser.props.length, 1);
      });

    });
  });
}