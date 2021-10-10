import 'package:example_with_automated_test/users/firebase_users_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../../hooks/hooks.dart';
import '../../steps/steps.dart';
import '../../steps/when_tap_step_override.dart';
import '../../support/firebase_world.dart';
import '../../../../lib/src/binding/binding_no_delay.dart';
import 'mock.dart';
import 'package:example_with_automated_test/app/flavors/main_unit.dart' as app;

void executeTestBase(
    void Function(TestConfiguration configuration,
            void Function(World) appMainFunction)
        executeTestSuite) {
  final firebaseHook =
      FirebaseSetupHook(firebaseManagementServiceBuilder: () => null);

  executeTestSuite(
    FlutterTestConfiguration.DEFAULT(
        [if (AutomatedBindingNoDelay.initialized) whenTapOverride, ...steps])
      ..customStepParameterDefinitions = [tableParameter]
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        JsonReporter(path: './report.json', writeReport: (_, __) async {}),
      ]
      ..hooks = [
        firebaseHook,
      ]
      ..tagExpression = "not @ignore"
      ..defaultTimeout = Duration(minutes: 1)
      ..createWorld = (w) async {
        var mockFirebaseAuth = MockFirebaseAuth();
        var fakeFirebaseFirestore = FakeFirebaseFirestore();
        return FirebaseWorld(
            auth: mockFirebaseAuth,
            firestore: fakeFirebaseFirestore,
            functions: MockFirebaseFunctions(
                mockFirebaseAuth, UsersRepository(fakeFirebaseFirestore)));
      },
    (world) {
      if (world is FirebaseWorld) {
        return app.mainUnit(
          firebaseAuth: world.auth,
          firestore: world.firestore,
          firebaseFunctions: world.functions,
        );
      }
    },
  );
}
