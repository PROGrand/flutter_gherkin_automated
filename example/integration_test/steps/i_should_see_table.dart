import 'package:example_with_automated_test/ui/shared/cells.dart';
import 'package:flutter_gherkin_integration/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:recase/recase.dart';

final shouldSeeTable = then2<String, GherkinTable, FlutterWorld>(
    RegExp(r'I (?:should|expect to) see the following (.+?):$'),
    (table, dataTable, context) async {
  await context.world.appDriver.waitForAppToSettle();

  final tableKey = table.camelCase;

  final cells = await context.world.appDriver.findByDescendant(
      context.world.appDriver.findBy(tableKey, FindType.key),
      context.world.appDriver.findBy(Cell, FindType.type),
      firstMatchOnly: false) as Finder;

  final cellsList = cells.evaluate().toList(growable: false);

  var n = 0;
  for (final row in dataTable.rows) {
    for (final expectedText in row.columns) {
      expect(null != expectedText, true);
      expect(cellsList.length > n, true,
          reason: cellsList.isEmpty
              ? 'table [$tableKey] not found or empty'
              : 'table [$tableKey] cells count ${cellsList.length} less than expected');
      if (cellsList.length <= n) return;

      var availText = cellsList[n].toStringDeep();

      var searchText = '"$expectedText"';
      final contains = availText.contains(searchText);
      expect(contains, true,
          reason: '$searchText is not in users table cell $availText');
      n++;
    }
  }

  await context.world.appDriver.waitForAppToSettle();
});
