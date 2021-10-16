import 'package:example_with_automated_test/ui/auth/auth_page.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

final givenISignIn = given2<String, String, FlutterWorld>(
    RegExp(r'I sign in with email {string} and password {string}'),
    (email, password, context) async {
  final emailField = context.world.appDriver.findBy('email', FindType.key);
  final passwordField =
      context.world.appDriver.findBy('password', FindType.key);
  final loginButton =
      context.world.appDriver.findBy('loginButton', FindType.key);

  await context.world.appDriver.nativeDriver.enterText(emailField, email);

  await context.world.appDriver.nativeDriver.enterText(passwordField, password);

  await context.world.appDriver.nativeDriver.tap(loginButton);

  await context.world.appDriver.waitUntil(
    () async {
      await context.world.appDriver.waitForAppToSettle();

      return context.world.appDriver.isAbsent(
        context.world.appDriver.findBy(AuthPage, FindType.type),
      );
    },
  );
});
