import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../integration_test/automated/features/user_list.dart'
    as user_list;

@GherkinAutomatedTestSuite()
void main() {
  AutomatedBindingNoDelay.init();

  group("[Unit]", () {
    user_list.main();
  });
}
