import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../app_config.dart';

void mainUnit({
  required FirebaseAuth firebaseAuth,
  required FirebaseFirestore firestore,
  required FirebaseFunctions firebaseFunctions,
}) async {
  await main();
}

Future main() async {
  await Firebase.initializeApp();

  await FirebaseInjector(
    environment: AppEnvironment.development,
    appName: 'Example (Dev)',
    useAuthenticationEmulator: true,
    useFirestoreEmulator: true,
    useFunctionsEmulator: true,
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    firebaseFunctions: FirebaseFunctions.instance,
  ).run();
}
