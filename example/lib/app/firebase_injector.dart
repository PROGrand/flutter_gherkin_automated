import 'package:flutter/material.dart';

class FlutterAppError extends StatelessWidget {
  final String appName;

  const FlutterAppError({required this.appName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: Center(
        child: Text(
          "Something won't wrong when initializing the app. Please contact support.",
        ),
      ),
    );
  }
}
