import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example_with_automated_test/admin/admin_result.dart';
import 'package:example_with_automated_test/common/development_mode.dart';
import '../admin/admin_service_interface.dart';
import '../common/bloc/action_cubit.dart';

import 'users_events.dart';
import 'users_repository_interface.dart';
import 'users_state.dart';

class UserActionCubit extends ActionCubit {}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserActionCubit _action;

  UsersBloc({
    required IAdminService adminService,
    required IUsersRepository usersRepository,
    required UserActionCubit action,
  })  : _adminService = adminService,
        _usersRepository = usersRepository,
        _action = action,
        super(UsersLoading()) {
    on<AddUser>(_onAddUser);
    on<UsersUpdated>(_onUsersUpdated);

    _usersSubscription = _usersRepository.users().listen((users) {
      add(UsersUpdated(users));
    });
  }

  final IAdminService _adminService;
  final IUsersRepository _usersRepository;

  StreamSubscription? _usersSubscription;

  Future<void> _onAddUser(AddUser event, Emitter<UsersState> emit) async {
    _action.start();

    if (!DevelopmentMode.minimizeDelays) {
      // Give waiting widget a chance...
      await Future.delayed(Duration(milliseconds: 100));
    }

    final result = await _adminService.createUser(user: event.user, email: event.email, password: event.password);

    if (result is AdminResultSuccess) {
      _action.done(result.id);
    } else if (result is AdminResultError) {
      _action.error('Unable to add new user.');
    }
  }

  void _onUsersUpdated(UsersUpdated event, Emitter<UsersState> emit) {
    emit(UsersReady(event.users));
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
