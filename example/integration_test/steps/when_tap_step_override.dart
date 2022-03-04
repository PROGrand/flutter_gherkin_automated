import 'package:flutter_gherkin_integration/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

final whenTapOverride = when1<String, FlutterWorld>(
  RegExp(r'I tap the {string} button$'),
  (key, context) async {
    await context.world.appDriver.waitForAppToSettle();
    final finder = context.world.appDriver.findBy(key, FindType.key);

    await context.world.appDriver.tap(
      finder,
      timeout: context.configuration.timeout,
    );

    await context.world.appDriver.waitForAppToSettle();
    //await context.world.appDriver.waitForAppToSettle();
  },
);
