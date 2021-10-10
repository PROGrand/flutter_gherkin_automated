import '../auth/auth_email_validator_interface.dart';

import 'user_validation_controller_interface.dart';

class UserValidationController implements IUserValidationController {
  final IAuthEmailValidator _validator;

  UserValidationController(this._validator);

  @override
  bool emailIsValid(String? email) => _validator.validate(email ?? "");
}
