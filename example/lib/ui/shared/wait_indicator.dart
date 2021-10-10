import 'package:flutter/material.dart';

class WaitIndicator extends StatelessWidget {
  const WaitIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
