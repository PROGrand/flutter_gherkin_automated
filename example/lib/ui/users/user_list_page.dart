import 'package:example_with_automated_test/auth/bloc.dart';
import 'package:example_with_automated_test/users/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_list_screen.dart';

class UserListPage extends Page {
  final AuthBloc authBloc;
  final UsersBloc userBloc;
  final UserActionCubit userActionCubit;

  UserListPage({
    required LocalKey key,
    required this.authBloc,
    required this.userBloc,
    required this.userActionCubit,
  }) : super(key: key);

  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<UsersBloc>.value(value: userBloc),
            BlocProvider<UserActionCubit>.value(value: userActionCubit),
          ],
          child: UserListScreen(key: ValueKey("userListScreen")),
        ),
      );
}
