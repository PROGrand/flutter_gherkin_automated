import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import '../../../integration_test/automated/features/authentication.dart'
    as authentication;

@GherkinAutomatedTestSuite()
void main() {
  AutomatedBindingNoDelay.init();
  authentication.main();
}
