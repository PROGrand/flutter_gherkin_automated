# Fast automated test example

Example uses FirabaseAuth, FirebaseFirestore and FirebaseFunctions to maintain authenticated users collection in for of:
    'users' : [ {'name': '<user-name>'}]
	
Two gherkin feature files used to demonstrate BDD test scenarios.

## After each feature files edit
    flutter pub run build_runner clean && flutter pub run build_runner build --delete-conflicting-outputs

## Integration tests

### Prepare integration test with firebase emulator
    npm install -g firebase-tools
    (optional) firebase login
    npm install -g chromedriver

### Start chromedriver
    (in first terminal) cd tools && ./0.0.start_chromedriver.sh

### Start firebase emulator	
	(in second terminal) cd tools && ./0.1.start_emulators.sh

### Run intergration tests
    (in third terminal) cd tools && ___0.2.scenarios_run.sh
	
## Fast unit and coverage tests
	flutter test -j 4 --coverage
	lcov -l coverage/lcov.info
	
## Performance
 Compare duration of `flutter drive` and `flutter test`. 