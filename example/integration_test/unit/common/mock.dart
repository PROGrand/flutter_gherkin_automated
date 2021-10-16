import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:example_with_automated_test/users/users_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:example_with_automated_test/users/user_entity.dart' as entity;

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  Map<String, Map<String, dynamic>> users = {};

  @override
  Future<void> useAuthEmulator(String host, int port) async {}

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    if (users.containsKey(email)) {
      throw FirebaseAuthException(code: '**already exists**');
    }

    var u = MockUserCredential(email);
    users[email] = {'email': email, 'password': password, 'credential': u};
    return u;
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    if (users.containsKey(email) && users[email]!['password'] == password) {
      if (users[email]!['disabled'] == true) {
        throw FirebaseAuthException(code: 'user-disabled');
      }

      return users[email]!['credential'];
    }

    throw FirebaseAuthException(code: '**invalid**');
  }

  void disableUser(String email) {
    if (users.containsKey(email)) {
      users[email]!["disabled"] = true;
    }
  }

  void clear() {
    users.clear();
  }
}

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  final Map<String, String> _jsonStore = <String, String>{};

  FirebaseAuth _firebaseAuth;
  IUsersRepository _repository;

  MockFirebaseFunctions(FirebaseAuth firebaseAuth, IUsersRepository repository)
      : _firebaseAuth = firebaseAuth,
        _repository = repository {}

  String _convertMapToJson(Map<String, dynamic> parameters) {
    return json.encode(parameters);
  }

  void mockResult({
    String? functionName,
    Map<String, dynamic>? parameters,
    String? result,
  }) {
    if (functionName != null && result != null) {
      if (parameters?.isNotEmpty == true) {
        functionName = functionName + _convertMapToJson(parameters!);
      }
      _jsonStore[functionName] = result;
    }
  }

  Future<String> getMockResult(
      String functionName, Map<String, dynamic>? parameters) async {
    if (functionName == "createUser") {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: parameters!["email"],
        password: parameters["password"],
      );

      await _repository.addNewUser(
          parameters["email"], entity.User(name: parameters["name"]));
    } else if (functionName == "disableUser") {
      (_firebaseAuth as MockFirebaseAuth).disableUser(parameters!["uid"]);
    }

    // ignore: parameter_assignments
    functionName = parameters == null
        ? functionName
        : (parameters.isNotEmpty == true
            ? functionName + _convertMapToJson(parameters)
            : functionName);
    assert(_jsonStore[functionName] != null,
        'No mock result for $functionName. \n Expected one of ${_jsonStore.keys}');
    return _jsonStore[functionName]!;
  }

  @override
  HttpsCallable httpsCallable(String functionName,
      {HttpsCallableOptions? options}) {
    return HttpsCallableMock._(this, functionName);
  }
}

class HttpsCallableMock extends Mock implements HttpsCallable {
  HttpsCallableMock._(this._firebaseFunctions, this._functionName);

  final MockFirebaseFunctions _firebaseFunctions;
  final String _functionName;

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    final decoded = json.decode(await _firebaseFunctions.getMockResult(
        _functionName, parameters as Map<String, dynamic>));
    return Future.value(HttpsCallableResultMock<T>._(decoded));
  }

  /// The timeout to use when calling the function. Defaults to 60 seconds.
  Duration? timeout;
}

class HttpsCallableResultMock<T> extends Mock
    implements HttpsCallableResult<T> {
  HttpsCallableResultMock._(this.data);

  /// Returns the data that was returned from the Callable HTTPS trigger.
  @override
  final T data;
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential(this.email);

  final String email;

  @override
  User? get user => MockUser(email);
}

class MockUser extends Mock implements User {
  MockUser(this.email_);

  final String email_;

  @override
  String? get email => email_;

  @override
  String get uid => email_;
}
