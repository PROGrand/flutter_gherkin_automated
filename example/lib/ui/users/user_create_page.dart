import 'package:example_with_automated_test/users/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_create_screen.dart';

class CreateUserPage extends Page {
  final UsersBloc userBloc;
  final UserActionCubit userActionCubit;

  CreateUserPage({
    required LocalKey key,
    required this.userBloc,
    required this.userActionCubit,
  }) : super(key: key);

  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<UsersBloc>.value(value: userBloc),
            BlocProvider<UserActionCubit>.value(value: userActionCubit),
          ],
          child: CreateUserForm(key: ValueKey("createUserForm")),
        ),
      );
}
