import 'package:example_with_automated_test/auth/auth_validation_controller_interface.dart';
import 'package:example_with_automated_test/auth/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class AuthPage extends Page {
  final AuthBloc authBloc;
  final IAuthValidationController _validationController;

  AuthPage({
    required LocalKey key,
    required this.authBloc,
    required IAuthValidationController validationController,
  })  : _validationController = validationController,
        super(key: key);

  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return Provider<IAuthValidationController>(
            create: (_) => _validationController,
            child: BlocProvider<AuthBloc>.value(
              value: authBloc,
              child: AuthScreen(key: ValueKey("AuthScreen")),
            ),
          );
        },
      );
}
