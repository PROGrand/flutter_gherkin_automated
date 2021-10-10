import 'package:example_with_automated_test/admin/admin_service.dart';
import 'package:example_with_automated_test/users/user_entity.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:recase/recase.dart';

import '../support/firebase_world.dart';

final collectionExists = given2<String, GherkinTable, FlutterWorld>(
    RegExp(r'(?:Following|following) (.+?) exists:$'),
    (table, dataTable, context) async {
  expect(context.world is FirebaseWorld, true);

  final world = context.world as FirebaseWorld;

  await world.appDriver.waitForAppToSettle();

  final tableKey = table.camelCase;

  for (final row in dataTable.rows) {
    var headers = dataTable.header!.columns.toList(growable: false);
    var data = row.columns.toList(growable: false);

    final Map<String, dynamic> record = {};

    for (var n = 1; n < headers.length; n++) {
      record[headers[n] as String] = data[n];
    }

    if (tableKey == 'users') {
      await AdminService(firebaseFunctions: world.functions).createUser(
          user: User(id: data[0], name: data[1] as String),
          email: data[0] as String,
          password: data[2] as String);
    } else {
      await world.firestore.collection(tableKey).doc(data[0]).set(record);
    }
  }

  await world.appDriver.waitForAppToSettle();
});
