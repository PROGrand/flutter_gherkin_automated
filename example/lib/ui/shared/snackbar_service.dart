import 'package:flutter/material.dart';

abstract class SnackbarService {
  static void show(
      {required BuildContext context,
      required Key key,
      required String message,
      Key? actionKey,
      String? actionLabel,
      VoidCallback? actionOnPressed,
      Color? background}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final _snackbar = SnackBar(
      content: Container(key: key, child: Text(message)),
      backgroundColor: background ?? Colors.red,
      action:
          actionKey != null && actionLabel != null && actionOnPressed != null
              ? SnackBarAction(
                  key: actionKey,
                  label: actionLabel,
                  onPressed: actionOnPressed)
              : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }
}
