import 'package:gherkin/gherkin.dart';

import '../support/firebase_management_service.dart';

class FirebaseSetupHook extends Hook {
  FirebaseSetupHook({
    required this.firebaseManagementServiceBuilder,
  });

  final FirebaseManagementService? Function() firebaseManagementServiceBuilder;

  FirebaseManagementService? firebaseManagementService;

  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario, Iterable<Tag> tags) {
    firebaseManagementService = firebaseManagementServiceBuilder();

    return super.onBeforeScenario(config, scenario, tags);
  }

  @override
  Future<void> onAfterScenarioWorldCreated(
      World world, String scenario, Iterable<Tag> tags) async {
    await firebaseManagementService?.clearAllData;

    // for (var user in testUsers) {
    //   await AuthenticationService(firebaseAuth!, firestore!).addUser(user);
    // }
  }

  @override
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario, Iterable<Tag> tags) {
    return super.onAfterScenario(config, scenario, tags);
  }
}
