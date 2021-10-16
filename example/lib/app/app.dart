import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_with_automated_test/admin/admin_service_interface.dart';
import 'package:example_with_automated_test/auth/auth_email_validator.dart';
import 'package:example_with_automated_test/auth/auth_listener.dart';
import 'package:example_with_automated_test/auth/auth_repository.dart';
import 'package:example_with_automated_test/auth/auth_repository_interface.dart';
import 'package:example_with_automated_test/auth/auth_validation_controller.dart';
import 'package:example_with_automated_test/auth/bloc.dart';
import 'package:example_with_automated_test/ui/auth/auth_page.dart';
import 'package:example_with_automated_test/ui/users/user_create_page.dart';
import 'package:example_with_automated_test/ui/users/user_list_page.dart';
import 'package:example_with_automated_test/users/firebase_users_repository.dart';
import 'package:example_with_automated_test/users/users_bloc.dart';
import 'package:example_with_automated_test/users/users_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App(
      {Key? key,
      required this.adminService,
      required this.firebaseAuth,
      required this.firestore,
      required this.appName})
      : super(key: key);

  final IAdminService adminService;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final String appName;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final IUsersRepository _usersRepository;

  late final AuthBloc _authBloc;
  late final UsersBloc _userBloc;
  late final UserActionCubit _userActionCubit;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _usersRepository = UsersRepository(widget.firestore);

    _userActionCubit = UserActionCubit();
    _userBloc = UsersBloc(
      adminService: widget.adminService,
      usersRepository: _usersRepository,
      action: _userActionCubit,
    );

    IAuthRepository _authRepository = AuthRepository(
      firebaseAuth: widget.firebaseAuth,
      usersRepository: _usersRepository,
    );
    _authBloc = AuthBloc(_authRepository);

    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => AuthPage(
            key: state.pageKey,
            authBloc: _authBloc,
            validationController:
                AuthValidationController(AuthEmailValidator()),
          ),
        ),
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) => UserListPage(
            key: state.pageKey,
            authBloc: _authBloc,
            userBloc: _userBloc,
            userActionCubit: _userActionCubit,
          ),
        ),
        GoRoute(
          path: '/users/add',
          pageBuilder: (context, state) => CreateUserPage(
            key: state.pageKey,
            userBloc: _userBloc,
            userActionCubit: _userActionCubit,
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: Text("${state.error}"),
      ),
      redirect: (state) {
        final loggedIn = _authBloc.state is AuthLoggedIn;
        final goingToLogin = state.location == '/';

        // the user is not logged in and not headed to /login, they need to login
        if (!loggedIn && !goingToLogin) return '/';

        // the user is logged in and headed to /login, no need to login again
        if (loggedIn && goingToLogin) return '/users';

        // no need to redirect at all
        return null;
      },
      refreshListenable: AuthListener(_authBloc),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: widget.appName,
      );

  @override
  void dispose() {
    _authBloc.close();
    _userBloc.close();
    _userActionCubit.close();
    super.dispose();
  }
}
