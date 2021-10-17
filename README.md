# flutter_gherkin_automated
Improved flutter gherkin [performance](#performance) and [stability](#stability)

## Performance

### Preliminary: integration tests performance vs. development
Original flutter_gherkin BDD test generator uses integration test bindings only.
It takes seconds for each 'Tap button' and etc. Simple feature takes minutes.
While such behaviour is appropriate for real world testing it make BDD completely unusable at development stage.

### Solution
Prepare test for each feature in `test/bdd/features/` using `@GherkinAutomatedTestSuite` annotation:
```dart
// file: test/bdd/features/some_feature1.dart
@GherkinAutomatedTestSuite()
void main() {
  AutomatedBindingNoDelay.init();

  group("[Unit]", () {
    some_feature1.main();
  });
}
```
    
Combine them all in `test/bdd/bdd_test.dart`:
```dart
// file: test/bdd/bdd_test.dart
void main() {
  AutomatedBindingNoDelay.init();

  group("[Gherkin]", () {
    some_feature1.main();
    some_feature2.main();
  });
}
```
### flutter test vs flutter driver
I already has 4x speed improvement using custom integration testing bindings and `flutter test` instead of `flutter drive`.
Also `flutter test` gives me ability to perform debug and coverage analysis.

`flutter test` based on automated binding. It is suitable for development. And gives ability to test, debug and coverage of particular features.

`flutter drive` based on integration binding. It can be invoked sometimes.

I do both on CI server.

I use automated test on development machine for each code change:

```sh
# particular feature test
flutter test test/bdd/features/some_feature1.dart
# complete test
flutter test --coverage -j 10)
```
    
and for integration test before project release:

```sh
flutter drive --driver=test_driver/integration_test_driver.dart \
    --target=integration_test/gherkin_suite_test_fast.dart -d web-server
```
    
### Results
I have more than 40X speed improvement on i9:

![image](https://user-images.githubusercontent.com/8981380/136713968-ee3a2dee-e03c-42e2-b6cb-d1b0da6ede2d.png)

## Stability

### Semantics
In flutter 2.5.0-2.5.2 there is regression.
Integration tests occasionally terminate with exceptions like "Parent #24 has child #29 but child #29 is attached to #30..." and etc.
Do not try to search root of problem in your code. Very simple widgets can stop working. It is just regression bug in flutter.

### Solution
I provide special `@GherkinNoSemanticsTestSuite` annotation for integration testing.

```dart
//integration_test/gherkin_suite_test.dart
@GherkinNoSemanticsTestSuite()
void main() async {
  await Firebase.initializeApp();
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT(),
    (World world) => app.main(),
  );
}
```
