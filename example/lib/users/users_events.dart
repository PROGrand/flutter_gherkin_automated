import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'user_entity.dart';

@immutable
abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class AddUser extends UsersEvent {
  final User user;
  final String email;
  final String password;

  const AddUser(this.user, {required this.email, required this.password});

  @override
  List<Object> get props => [user, email, password];

  @override
  String toString() =>
      'AddUser { user: $user, email: $email, password: ${password.hashCode} }';
}

class UsersUpdated extends UsersEvent {
  final List<User> users;

  const UsersUpdated(this.users);

  @override
  List<Object> get props => [users];
}
