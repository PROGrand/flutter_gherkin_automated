import 'package:flutter_gherkin_automated/src/code_generation/annotations/gherkin_full_automated_test_suite_annotation.dart';
import 'package:flutter_gherkin_automated/src/runners/gherkin_automated_test_runner.dart';
import 'package:gherkin/gherkin.dart';

import '../../unit/common/testBase.dart';

part 'authentication.g.dart';

@GherkinAutomatedTestSuite(featurePaths: ['integration_test/features/authentication.feature'])
void main() {
  executeTestBase(executeTestSuite);
}

