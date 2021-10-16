import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:source_gen/source_gen.dart';
import '../annotations/gherkin_full_automated_test_suite_annotation.dart';

class _NoOpReporter extends Reporter {}

class GherkinSuiteAutomatedTestGenerator
    extends GeneratorForAnnotation<GherkinAutomatedTestSuite> {
  static const String TEMPLATE = '''
class _CustomGherkinAutomatedTestRunner extends GherkinAutomatedTestRunner {
  _CustomGherkinAutomatedTestRunner(
    TestConfiguration configuration,
    void Function(World) appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    {{features_to_execute}}
  }

  {{feature_functions}}
}

void executeTestSuite(
  TestConfiguration configuration,
  void Function(World) appMainFunction,
) {
  _CustomGherkinAutomatedTestRunner(configuration, appMainFunction).run();
}
''';
  final _reporter = _NoOpReporter();
  final _languageService = LanguageService();

  @override
  Future<String> generateForAnnotatedElement(
      Element element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) async {
    _languageService.initialise(
      annotation.read('featureDefaultLanguage').literalValue.toString(),
    );
    final idx = annotation
        .read('executionOrder')
        .objectValue
        .getField('index')!
        .toIntValue()!;
    final executionOrder = ExecutionOrder.values[idx];
    final featureFiles = annotation
        .read('featurePaths')
        .listValue
        .map((path) => Glob(path.toStringValue()!))
        .map(
          (glob) => glob
          .listSync()
          .map((entity) => File(entity.path).readAsStringSync())
          .toList(),
    )
        .reduce((value, element) => value..addAll(element));

    if (executionOrder == ExecutionOrder.random) {
      featureFiles.shuffle();
    }

    final featureExecutionFunctionsBuilder = StringBuffer();
    final generator = FeatureFileTestGenerator();
    var id = 0;

    for (var featureFileContent in featureFiles) {
      final code = await generator.generate(
        id++,
        featureFileContent,
        '',
        _languageService,
        _reporter,
      );
      featureExecutionFunctionsBuilder.writeln(code);
    }

    return TEMPLATE
        .replaceAll('{{feature_functions}}',
        featureExecutionFunctionsBuilder.toString())
        .replaceAll(
      '{{features_to_execute}}',
      List.generate(
        id,
            (index) => 'testFeature$index();',
        growable: false,
      ).join('\n'),
    );
  }
}

class FeatureFileTestGenerator {
  Future<String> generate(
      int id,
      String featureFileContents,
      String path,
      LanguageService languageService,
      Reporter reporter,
      ) async {
    final visitor = FeatureFileTestGeneratorVisitor();

    return await visitor.generateTests(
      id,
      featureFileContents,
      path,
      languageService,
      reporter,
    );
  }
}

class FeatureFileTestGeneratorVisitor extends FeatureFileVisitor {
  static const String FUNCTION_TEMPLATE = '''
  void testFeature{{feature_number}}() {
    runFeature(
      '{{feature_name}}:',
      {{tags}},
      () {
        {{scenarios}}
      },
    );
  }
  ''';
  static const String SCENARIO_TEMPLATE = '''
  runScenario(
    '{{scenario_name}}',
    {{tags}},
    (AutomatedTestDependencies dependencies) async {
      {{steps}}
    },
    onBefore: {{onBefore}},
    onAfter: {{onAfter}},
  );
  ''';
  static const String STEP_TEMPLATE = '''
  await runStep(
    '{{step_name}}',
    {{step_multi_line_strings}},
    {{step_table}},
    dependencies,
  );
  ''';
  static const String ON_BEFORE_SCENARIO_RUN = '''
  () async => onBeforeRunFeature('{{scenario_name}}', {{tags}},)
  ''';
  static const String ON_AFTER_SCENARIO_RUN = '''
  () async => onAfterRunFeature('{{scenario_name}}',)
  ''';

  final StringBuffer _buffer = StringBuffer();
  int? _id;
  String? _currentFeatureCode;
  String? _currentScenarioCode;
  final StringBuffer _scenarioBuffer = StringBuffer();
  final StringBuffer _stepBuffer = StringBuffer();

  Future<String> generateTests(
      int id,
      String featureFileContents,
      String path,
      LanguageService languageService,
      Reporter reporter,
      ) async {
    _id = id;
    await visit(
      featureFileContents,
      path,
      languageService,
      reporter,
    );

    _flushScenario();
    _flushFeature();

    return _buffer.toString();
  }

  @override
  Future<void> visitFeature(
      String name,
      String? description,
      Iterable<String> tags,
      ) async {
    _currentFeatureCode = _replaceVariable(
      FUNCTION_TEMPLATE,
      'feature_number',
      _id.toString(),
    );
    _currentFeatureCode = _replaceVariable(
      _currentFeatureCode!,
      'feature_name',
      _escapeText(name),
    );
    _currentFeatureCode = _replaceVariable(
      _currentFeatureCode!,
      'tags',
      '<String>[${tags.map((e) => "'$e'").join(', ')}]',
    );
  }

  @override
  Future<void> visitScenario(
      String name,
      Iterable<String> tags,
      bool isFirst,
      bool isLast,
      ) async {
    _flushScenario();
    _currentScenarioCode = _replaceVariable(
      SCENARIO_TEMPLATE,
      'onBefore',
      isFirst ? ON_BEFORE_SCENARIO_RUN : 'null',
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'onAfter',
      isLast ? ON_AFTER_SCENARIO_RUN : 'null',
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'scenario_name',
      _escapeText(name),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'tags',
      '<String>[${tags.map((e) => "'$e'").join(', ')}]',
    );
  }

  @override
  Future<void> visitScenarioStep(
      String name,
      Iterable<String> multiLineStrings,
      GherkinTable? table,
      ) async {
    var code = _replaceVariable(
      STEP_TEMPLATE,
      'step_name',
      _escapeText(name),
    );
    code = _replaceVariable(
      code,
      'step_multi_line_strings',
      // '<String>[${multiLineStrings.map((s) => "'${_escapeText(s)}'").join(',')}]',
      '<String>[${multiLineStrings.map((s) => '"""$s"""').join(',')}]',
    );
    code = _replaceVariable(
      code,
      'step_table',
      table == null ? 'null' : 'GherkinTable.fromJson(\'${table.toJson()}\')',
    );

    _stepBuffer.writeln(code);
  }

  void _flushFeature() {
    if (_currentFeatureCode != null) {
      _currentFeatureCode = _replaceVariable(
        _currentFeatureCode!,
        'scenarios',
        _scenarioBuffer.toString(),
      );

      _buffer.writeln(_currentFeatureCode);
    }

    _currentFeatureCode = null;
    _scenarioBuffer.clear();
  }

  void _flushScenario() {
    if (_currentScenarioCode != null) {
      if (_stepBuffer.isNotEmpty) {
        _currentScenarioCode = _replaceVariable(
          _currentScenarioCode!,
          'steps',
          _stepBuffer.toString(),
        );
      }

      _scenarioBuffer.writeln(_currentScenarioCode);
    }

    _currentScenarioCode = null;
    _stepBuffer.clear();
  }

  String _replaceVariable(String content, String property, String value) {
    return content.replaceAll('{{$property}}', value);
  }

  String _escapeText(String text) => text.replaceAll("'", "\\'");
}
