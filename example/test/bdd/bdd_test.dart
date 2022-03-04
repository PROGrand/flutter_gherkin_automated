import 'package:flutter_gherkin_automated/flutter_gherkin_automated.dart';
import 'features/authentication.dart' as authentication;
import 'features/user_list.dart' as user_list;

void main() {
  AutomatedBindingNoDelay.init();
  user_list.main();
  authentication.main();
}
