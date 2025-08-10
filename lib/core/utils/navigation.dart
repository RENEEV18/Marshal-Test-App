import 'package:flutter/material.dart';

class AppNavigation {
  void pushNamed({required BuildContext context, required String route, Object? arguments}) {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  void pop({required BuildContext context}) {
    Navigator.of(context).pop();
  }

  void pushNamedRemoveUntil({required BuildContext context, required String route}) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }
}
