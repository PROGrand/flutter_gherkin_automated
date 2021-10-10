const String _testUserPassword = "myPassword";

final _testUserEmailPasswordMap = <String, String>{
  "myEmail@address.com": _testUserPassword
};

String testPasswordForUser({required String emailAddress}) =>
    _testUserEmailPasswordMap.containsKey(emailAddress)
        ? _testUserEmailPasswordMap[emailAddress]!
        : _testUserPassword;
