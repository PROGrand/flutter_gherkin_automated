import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/src/binding/binding_no_delay.dart';
import '../../../integration_test/automated/features/authentication.dart' as authentication;

@GherkinAutomatedTestSuite()
void main() {
  AutomatedBindingNoDelay.init();

  group("[Unit]", () {
    authentication.main();
  });
}
