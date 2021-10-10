import 'package:gherkin/gherkin.dart';

import 'collection_exists.dart';
import 'given_i_sign_in.dart';
import 'i_should_see_table.dart';
import 'i_sign_out.dart';
import 'user_has_password.dart';

final steps = [
  collectionExists,
  givenISignIn,
  shouldSeeTable,
  iSignOut,
  userHasPassword,
];

class TableParameter extends CustomParameter<String> {
  TableParameter()
      : super("table", RegExp(r"([^\s^\:]+)", caseSensitive: true), (c) => c);
}

final tableParameter = TableParameter();
