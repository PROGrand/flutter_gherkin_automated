import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:example_with_automated_test/app/firebase_injector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

void main() {
  group('errors', () {
    testWidgets('handle wrong firebase implementation',
        (WidgetTester tester) async {
      FirebaseInjector(
        environment: AppEnvironment.development,
        appName: 'Example (Dev)',
        useAuthenticationEmulator: true,
        useFirestoreEmulator: true,
        useFunctionsEmulator: true,
        firebaseAuth: MockFirebaseAuth(),
        firestore: MockFirebaseFirestore(),
        firebaseFunctions: MockFirebaseFunctions(),
      ).run();

      await tester.pumpAndSettle();

      final finder = find.text(
          'Something won\'t wrong when initializing the app. Please contact support.');

      expect(finder, findsOneWidget);
    });
  });
}
