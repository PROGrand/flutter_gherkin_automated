import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'package:gherkin/gherkin.dart';

import '../../unit/common/testBase.dart';

part 'user_list.g.dart';

@GherkinAutomatedTestSuite(featurePaths: ['integration_test/features/user_list.feature'])
void main() {
  executeTestBase(executeTestSuite);
}

