import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

final iSignOut = given<FlutterWorld>('I sign out', (context) async {
  final logOutButton = context.world.appDriver.findBy('logOut', FindType.key);

  await context.world.appDriver.tap(logOutButton);
  await context.world.appDriver.waitForAppToSettle();
});
