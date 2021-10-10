import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_bloc.dart';
import 'auth_state.dart';

class AuthListener extends ChangeNotifier {
  late AuthState state;

  late final StreamSubscription _streamSubscription;

  AuthListener(AuthBloc bloc) {
    state = bloc.state;

    _streamSubscription = bloc.stream.listen((event) {
      state = event;
      this.notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
