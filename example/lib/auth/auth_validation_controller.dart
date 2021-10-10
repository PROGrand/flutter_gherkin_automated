import 'auth_validation_controller_interface.dart';
import 'auth_email_validator_interface.dart';

class AuthValidationController implements IAuthValidationController {
  final IAuthEmailValidator _validator;

  AuthValidationController(this._validator);

  @override
  bool emailIsValid(String? email) => _validator.validate(email ?? "");

  @override
  bool passwordIsValid(String? password) => (password ?? "").isNotEmpty;
}
