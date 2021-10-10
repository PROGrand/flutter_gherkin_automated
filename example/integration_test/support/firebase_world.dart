import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class FirebaseWorld extends FlutterWorld {
  FirebaseWorld(
      {required this.auth, required this.firestore, required this.functions});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
}
