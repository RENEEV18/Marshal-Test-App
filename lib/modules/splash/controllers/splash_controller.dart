import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/routes/route_constants.dart';

class SplashController extends ChangeNotifier {
  // Controller function for the splas timer to login/home screen (LOGIC)
  void splashTimer({required BuildContext context}) {
    Timer(
      Duration(seconds: 3),
      () {
        AppNavigation().pushNamed(context: context, route: AppRouteConstants.loginRoute);
      },
    );
  }
}
