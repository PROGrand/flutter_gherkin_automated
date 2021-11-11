# flutter_gherkin_automated
Generate gherkin automated tests

## Preliminary: integration tests performance vs. development
Original flutter_gherkin BDD test generator uses integration test bindings only.
It takes seconds for each 'Tap button' and etc. Simple feature takes minutes.
While such behaviour is appropriate for real world testing it make BDD completely unusable at development stage.

## flutter test vs flutter driver
I already has 4x speed improvement using custom integration testing bindings and `flutter test` instead of `flutter drive`.
Also `flutter test` gives me ability to perform coverage analysis.

## AutomatedTestWidgetsFlutterBinding
Here i demonstrate automated bindings generator concept.

On some pre-production project i will use for automated test:

    time (flutter test --coverage -j 10)
    
and for integration test:

    time (flutter drive --driver=test_driver/integration_test_driver.dart \
        --target=integration_test/gherkin_suite_test_fast.dart -d web-server)
    
## Results
I have more than 40X speed improvement on i9:

![image](https://user-images.githubusercontent.com/8981380/136713968-ee3a2dee-e03c-42e2-b6cb-d1b0da6ede2d.png)



