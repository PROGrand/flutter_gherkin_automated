import 'package:flutter/widgets.dart';

class Cell extends StatelessWidget {
  final Widget child;

  const Cell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => child;

  @override
  String toStringDeep(
          {String prefixLineOne = '',
          String? prefixOtherLines,
          DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      child.toStringDeep(
          prefixLineOne: prefixLineOne,
          prefixOtherLines: prefixOtherLines,
          minLevel: minLevel);
}

class Header extends StatelessWidget {
  final Widget child;

  const Header({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => child;

  @override
  String toStringDeep(
          {String prefixLineOne = '',
          String? prefixOtherLines,
          DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      child.toStringDeep(
          prefixLineOne: prefixLineOne,
          prefixOtherLines: prefixOtherLines,
          minLevel: minLevel);
}
