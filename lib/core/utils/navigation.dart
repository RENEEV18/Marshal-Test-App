import 'package:flutter/material.dart';

class AppNavigation {
  void pushNamed({required BuildContext context, required String route}) {
    Navigator.of(context).pushNamed(route);
  }

  void pop({required BuildContext context}) {
    Navigator.of(context).pop();
  }

  void pushNamedRemoveUntil({required BuildContext context, required String route}) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }
}
