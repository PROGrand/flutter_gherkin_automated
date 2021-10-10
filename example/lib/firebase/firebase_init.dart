import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInit {
  static Future initialize({
    bool useAuthenticationEmulator = true,
    bool useFirestoreEmulator = true,
    bool useFunctionsEmulator = true,
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseFunctions firebaseFunctions,
  }) async {
    if (useAuthenticationEmulator)
      firebaseAuth.useAuthEmulator('localhost', 9099);

    if (useFirestoreEmulator) {
      try {
        firestore.useFirestoreEmulator('localhost', 8080);
      } catch (e) {}
    }

    if (useFunctionsEmulator) {
      firebaseFunctions.useFunctionsEmulator('localhost', 5001);
    }
  }
}
