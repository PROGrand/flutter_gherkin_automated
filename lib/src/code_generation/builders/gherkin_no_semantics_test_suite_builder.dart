library flutter_gherkin_automated.builder;

import 'package:build/build.dart';
import 'package:flutter_gherkin_automated/src/code_generation/generators/gherkin_suite_no_semantics_test_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder gherkinNoSemanticsTestSuiteBuilder(BuilderOptions options) =>
    SharedPartBuilder(
        [GherkinSuiteTestNoSemanticsGenerator()], 'gherkin_no_semantics_tests');
