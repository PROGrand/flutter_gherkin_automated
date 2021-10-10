import 'package:email_validator/email_validator.dart';

import 'auth_email_validator_interface.dart';

class AuthEmailValidator implements IAuthEmailValidator {
  @override
  bool validate(String email) => EmailValidator.validate(email);
}
