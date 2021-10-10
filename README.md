# flutter_gherkin_automated
Generate gherkin automated tests

## Preliminary: intergation tests performance vs. development
Original flutter_gherkin BDD test generator uses integration test bindings only.
It takes seconds for each 'Tap button' and etc. Simple feature takes minutes.
While such behaviour is appropriate for real world testing it make BDD completely unusable at development stage.

## flutter test vs flutter driver
I already has 4x speed improvement using custom integration testing bindings and `flutter test` instead of `flutter drive`.
Also `flutter test` gives me ability to perform coverage analysis.

## AutomatedTestWidgetsFlutterBinding
Here i will try automated bindings generator concept. Intermediate results...
