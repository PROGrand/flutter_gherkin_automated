import 'package:example_with_automated_test/auth/auth_credentials.dart';
import 'package:example_with_automated_test/auth/auth_validation_controller_interface.dart';
import 'package:example_with_automated_test/auth/bloc.dart';
import 'package:example_with_automated_test/common/development_mode.dart';
import 'package:example_with_automated_test/ui/shared/snackbar_service.dart';
import 'package:example_with_automated_test/ui/shared/wait_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late GlobalKey<FormState> _formKey;
  late IAuthValidationController _validationController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _validationController = context.read<IAuthValidationController>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    if (DevelopmentMode.useFastData) {
      _emailController.text = "user@example.com";
      _passwordController.text = "password";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  SnackbarService.show(
                    context: context,
                    key: ValueKey("loginErrorMessage"),
                    message: state.message,
                  );
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: ValueKey("email"),
                          controller: _emailController,
                          decoration:
                              InputDecoration(labelText: 'Email Address'),
                          validator: (String? email) =>
                              _validationController.emailIsValid(email)
                                  ? null
                                  : "The email address is invalid",
                        ),
                        TextFormField(
                          key: ValueKey("password"),
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (String? password) =>
                              _validationController.passwordIsValid(password)
                                  ? null
                                  : "No password provided",
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          child: (state is AuthLoading)
                              ? WaitIndicator()
                              : ElevatedButton(
                                  key: ValueKey("loginButton"),
                                  child: Text("Login"),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final _credentials = AuthCredentials(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      context
                                          .read<AuthBloc>()
                                          .add(AuthAttempt(_credentials));
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
