import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:example_with_automated_test/common/development_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../firebase_injector.dart';

/// {@template counter_observer}
/// [BlocObserver] for the counter application which
/// observes all state changes.
/// {@endtemplate}
class CounterObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() async {
  Bloc.observer = CounterObserver();
  DevelopmentMode.initialize(showErrors: true, useFastData: true);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseInjector(
    environment: AppEnvironment.development,
    appName: 'Example (Dev Fast)',
    useAuthenticationEmulator: true,
    useFirestoreEmulator: true,
    useFunctionsEmulator: true,
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    firebaseFunctions: FirebaseFunctions.instance,
  ).run();
}
