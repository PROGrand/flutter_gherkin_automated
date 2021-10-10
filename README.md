# flutter_gherkin_automated
Generate gherkin automated tests

## Preliminary
Original flutter_gherkin BDD test generator uses integration test bindings only.
It takes seconds second for each 'Tap button' and etc. Simple feature takes minutes.
It is appropriate for real world testing but making BDD completely unusable for me at development stage.

## flutter test vs flutter driver
I already has 4x speed improvement using custom integration testing bindings and `flutter test` instead of `flutter drive`.
Also `flutter test` gives me ability to perform coverage analysis.

## AutomatedTestWidgetsFlutterBinding
I will try automated bindings generator and collect performance results.
