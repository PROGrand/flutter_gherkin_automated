import 'dart:math';

import 'package:example_with_automated_test/auth/bloc.dart';
import 'package:example_with_automated_test/ui/shared/cells.dart';
import 'package:example_with_automated_test/ui/shared/wait_indicator.dart';
import 'package:example_with_automated_test/users/user_entity.dart';
import 'package:example_with_automated_test/users/users_bloc.dart';
import 'package:example_with_automated_test/users/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        body: Center(
            child: SizedBox(
          width: max(MediaQuery.of(context).size.width * 0.6, 640.0),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                key: ValueKey("addUser"),
                child: Text("Add User"),
                onPressed: () => context.push("/users/add"),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  key: ValueKey("logOut"),
                  child: Text("Log Out"),
                  onPressed: () => context.read<AuthBloc>().add(AuthLogout())),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
                if (state is UsersReady) {
                  final users = state.data;
                  return Expanded(
                      child: ListView.builder(
                          key: ValueKey('users'),
                          itemCount: users.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _UserHeaderListTile();
                            }
                            var user = users[index - 1];

                            return _UserListTile(user);
                          }));
                } else if (state is UsersLoading)
                  return WaitIndicator();
                else
                  return Center(child: Text('Assert: $state'));
              })
            ],
          ),
        )),
      ));
}

class _UserHeaderListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Header(child: Text("Name")),
          ]),
        ],
      ),
    );
  }
}

class _UserListTile extends StatefulWidget {
  final User user;

  _UserListTile(this.user);

  @override
  State<_UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<_UserListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Cell(
                child: Text(widget.user.name, key: ValueKey(widget.user.name)),
              ),
            ]),
          ],
        ),
      ),
      onTap: () => {},
    );
  }
}
