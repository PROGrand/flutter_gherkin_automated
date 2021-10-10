import 'package:email_validator/email_validator.dart';
import 'package:example_with_automated_test/common/bloc/action_cubit.dart';
import 'package:example_with_automated_test/common/development_mode.dart';
import 'package:example_with_automated_test/ui/shared/snackbar_service.dart';
import 'package:example_with_automated_test/ui/shared/wait_indicator.dart';
import 'package:example_with_automated_test/users/user_entity.dart';
import 'package:example_with_automated_test/users/users_bloc.dart';
import 'package:example_with_automated_test/users/users_events.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserForm extends StatefulWidget {
  CreateUserForm({Key? key}) : super(key: key);

  @override
  _CreateUserFormState createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _nameController;

  late final TextEditingController _emailAddressController;

  late final TextEditingController _passwordAddressController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    _nameController = TextEditingController();
    _emailAddressController = TextEditingController();
    _passwordAddressController = TextEditingController();

    if (DevelopmentMode.useFastData) {
      _nameController.text = 'Test User';
      _emailAddressController.text = 'user@example.com';
      _passwordAddressController.text = 'password';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailAddressController.dispose();
    _passwordAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    key: ValueKey("fullName"),
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (String? email) =>
                        email?.isNotEmpty == true ? null : "Name is missing",
                  ),
                  TextFormField(
                    key: ValueKey("emailAddress"),
                    controller: _emailAddressController,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (String? email) =>
                        (email == null || email.isEmpty)
                            ? "Email address is missing"
                            : !EmailValidator.validate(email)
                                ? "Email is invalid"
                                : null,
                  ),
                  TextFormField(
                    key: ValueKey("password"),
                    controller: _passwordAddressController,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (String? password) =>
                        (password == null || password.isEmpty)
                            ? "password is missing"
                            : null,
                  ),
                  SizedBox(height: 20),
                  BlocConsumer<UserActionCubit, ActionState>(
                    builder: (context, state) {
                      return state is ActionInProcess
                          ? WaitIndicator()
                          : buildButtons(context);
                    },
                    listener: (context, state) {
                      if (state is ActionComplete) {
                        setState(() {
                          SnackbarService.show(
                              context: context,
                              key: ValueKey('createUserMessage'),
                              message: 'Test User added successfully!',
                              background: Colors.green);
                        });
                      } else if (state is ActionError) {
                        setState(() {
                          SnackbarService.show(
                              context: context,
                              key: ValueKey('createUserErrorMessage'),
                              message: 'This user already exists!',
                              background: Colors.red);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ));

  Column buildButtons(BuildContext context) {
    return Column(children: [
      ElevatedButton(
          key: ValueKey("createUser"),
          onPressed: () async => _createUser(context),
          child: Text("Create User")),
      SizedBox(height: 20),
      ElevatedButton(
          onPressed: () async => _done(context), child: Text("Finish")),
      SizedBox(height: 20),
      ElevatedButton(
          onPressed: () async => _addAnotherUser(context),
          child: Text("Add Another User")),
    ]);
  }

  void _createUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<UsersBloc>().add(AddUser(User(name: _nameController.text),
          email: _emailAddressController.text,
          password: _passwordAddressController.text));
    }
  }

  void _done(BuildContext context) => Navigator.pop(context);

  void _addAnotherUser(BuildContext context) {
    _formKey.currentState?.reset();
  }
}
