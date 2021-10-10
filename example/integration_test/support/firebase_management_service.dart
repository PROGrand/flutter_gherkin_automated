import 'package:http/http.dart' as http;

class FirebaseManagementService {
  Future<void> get clearAllData async {
    await clearAuthUsers;
    await clearFirestoreData;
  }

  Future<void> get clearAuthUsers async {
    final endpoint =
        "http://localhost:9099/emulator/v1/projects/flutter-gherkin-automated/accounts";
    final headers = {"Authorization": "Bearer owner"};
    await http.delete(Uri.parse(endpoint), headers: headers);
  }

  Future<void> get clearFirestoreData async {
    final endpoint =
        "http://localhost:8080/emulator/v1/projects/flutter-gherkin-automated/databases/(default)/documents";
    await http.delete(Uri.parse(endpoint));
  }
}
