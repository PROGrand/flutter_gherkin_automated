# Fast automated test example

Example uses FirabaseAuth, FirebaseFirestore and FirebaseFunctions to maintain authenticated users collection in for of:
    'users' : [ {'name': '<user-name>'}]
	
Two gherkin feature files used to demonstrate BDD test scenarios.

## After each feature files edit
    flutter pub run build_runner clean && flutter pub run build_runner build --delete-conflicting-outputs

## Integration tests
### Prepare integration test with firebase emulator
    npm install -g firebase-tools
    firebase login
    npm install -g chromedriver
    cd tools/functions
    firebase init emulators --project flutter-gherkin-automated --config local.firebase.json
### Start chromedriver
    chromedriver --port=4444 --allowed-ips --readable-timestamp --log-path=chromedriver.log --enable-chrome-logs
### Start firebase emulator	
	firebase emulators:start --project flutter-gherkin-automated --config "base/local.firebase.json"
### Run intergration tests
    flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/gherkin_suite_test.dart -d web-server
	
## Fast unit and coverage tests
	flutter test --coverage
	lcov -l coverage/lcov.info
	
## Performance
 Compare duration of `flutter drive` and `flutter test`. 