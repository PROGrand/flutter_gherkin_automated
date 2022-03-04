import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gherkin_integration/flutter_gherkin.dart';
import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'package:gherkin/gherkin.dart';

import 'support/firebase_management_service.dart';
import 'hooks/firebase_setup_hook.dart';
import 'steps/steps.dart';
import 'package:example_with_automated_test/app/flavors/main_development.dart'
    as app;

import 'support/firebase_world.dart';

part 'gherkin_suite_test.g.dart';

@GherkinAutomatedTestSuite()
void main() async {
  await Firebase.initializeApp();

  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([...steps])
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
        JsonReporter(writeReport: (_, __) async {}),
      ]
      ..hooks = [
        FirebaseSetupHook(
          firebaseManagementServiceBuilder: () => FirebaseManagementService(),
        ),
      ]
      ..tagExpression = "not @ignore"
      ..defaultTimeout = Duration(minutes: 1)
      ..semanticsEnabled = false
      ..createWorld = (w) async => FirebaseWorld(
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
          functions: FirebaseFunctions.instance),
    (World world) => app.main(),
  );
}
