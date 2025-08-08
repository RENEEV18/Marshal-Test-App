import 'package:flutter/material.dart';

class AppNavigation {
  void pushNamed({required BuildContext context, required String route}) {
    Navigator.of(context).pushNamed(route);
  }

  void pushReplacement({required BuildContext context, required String route}) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
