import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'package:gherkin/gherkin.dart';

import '../../unit/common/testBase.dart';

part 'authentication.g.dart';

@GherkinAutomatedTestSuite(
    featurePaths: ['integration_test/features/authentication.feature'])
void main() {
  executeTestBase(executeTestSuite);
}
