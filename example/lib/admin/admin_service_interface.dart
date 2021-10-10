import '../users/user_entity.dart';

import 'admin_result.dart';

abstract class IAdminService {
  Future<AdminResult> createUser({required User user, required String email, required String password});
}
