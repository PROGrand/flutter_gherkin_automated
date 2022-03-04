import 'package:flutter_gherkin_integration/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:test/expect.dart';

final userHasPassword = given2<String, String, FlutterWorld>(
    RegExp(r'the user with email address {string} has password {string}'),
    (emailAddress, password, context) async {
  expect("password", password);
});
