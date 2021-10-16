library flutter_gherkin_automated.builder;

import 'package:build/build.dart';
import 'package:flutter_gherkin_automated/src/code_generation/generators/gherkin_suite_automated_test_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder gherkinAutomatedTestSuiteBuilder(BuilderOptions options) =>
    SharedPartBuilder(
        [GherkinSuiteAutomatedTestGenerator()], 'gherkin_automated_tests');
