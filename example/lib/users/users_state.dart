import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'user_entity.dart';

@immutable
abstract class UsersState extends Equatable {}

class UsersLoading extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersReady extends UsersState {
  final List<User> data;

  UsersReady(this.data);

  @override
  List<Object> get props => [data];
}
