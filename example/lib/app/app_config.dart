import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:example_with_automated_test/admin/admin_service.dart';
import 'package:example_with_automated_test/firebase/firebase_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_injector.dart';

enum AppEnvironment {
  development,
  production,
}

class FirebaseInjector {
  final AppEnvironment environment;
  final String appName;
  final bool useAuthenticationEmulator;
  final bool useFirestoreEmulator;
  final bool useFunctionsEmulator;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  FirebaseInjector({
    required this.environment,
    required this.appName,
    this.useAuthenticationEmulator = true,
    this.useFirestoreEmulator = true,
    this.useFunctionsEmulator = true,
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseFunctions,
  });

  Future run() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      final adminService = AdminService(firebaseFunctions: firebaseFunctions);

      await FirebaseInit.initialize(
          useAuthenticationEmulator: useAuthenticationEmulator,
          useFirestoreEmulator: useFirestoreEmulator,
          useFunctionsEmulator: useFunctionsEmulator,
          firebaseAuth: firebaseAuth,
          firestore: firestore,
          firebaseFunctions: firebaseFunctions);

      runApp(App(
        appName: appName,
        adminService: adminService,
        firebaseAuth: firebaseAuth,
        firestore: firestore,
      ));
    } on Exception catch (e) {
      print(e);
      runApp(FlutterAppError(appName: appName));
    }
  }
}
