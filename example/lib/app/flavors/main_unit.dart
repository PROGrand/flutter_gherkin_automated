import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:example_with_automated_test/app/firebase_injector.dart';
import 'package:firebase_auth/firebase_auth.dart';

void mainUnit({
  required FirebaseAuth firebaseAuth,
  required FirebaseFirestore firestore,
  required FirebaseFunctions firebaseFunctions,
}) async {
  await FirebaseInjector(
    environment: AppEnvironment.development,
    appName: 'Example (Automated Test)',
    useAuthenticationEmulator: true,
    useFirestoreEmulator: true,
    useFunctionsEmulator: true,
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    firebaseFunctions: firebaseFunctions,
  ).run();
}
