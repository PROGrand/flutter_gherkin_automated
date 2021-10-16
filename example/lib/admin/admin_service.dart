import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

import 'admin_result.dart';
import 'admin_service_interface.dart';
import '../users/user_entity.dart' as model;

class AdminService extends IAdminService {
  FirebaseFunctions _firebaseFunctions;

  AdminService({
    required FirebaseFunctions firebaseFunctions,
  }) : _firebaseFunctions = firebaseFunctions;

  Future<AdminResult> createUser(
      {required model.User user,
      required String email,
      required String password}) async {
    try {
      final map = {
        'email': email,
        'password': password,
        'name': user.name,
      };
      final httpsCallable = _firebaseFunctions.httpsCallable('createUser');

      final callableResult = await httpsCallable(map);

      final data = callableResult.data;

      return AdminResultSuccess(
          data is String ? jsonDecode(data)['uid'] : data['uid']);
    } catch (e) {
      return AdminResultError(e);
    }
  }
}
