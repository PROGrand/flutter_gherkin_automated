import 'package:flutter_test/flutter_test.dart';
import 'features/authentication.dart' as authentication;
import 'features/user_list.dart' as user_list;
import '../../../lib/src/binding/binding_no_delay.dart';

void main() {
  AutomatedBindingNoDelay.init();

  group("[Gherkin]", () {
    user_list.main();
    authentication.main();
  });
}
