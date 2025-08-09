import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';
import 'package:marshal_test_app/modules/auth/presentation/controllers/login_controller.dart';
import 'package:marshal_test_app/routes/route_constants.dart';

class SplashController extends ChangeNotifier {
  final LoginController loginController = LoginController();
  // Controller function for the splas timer to login/home screen (LOGIC)
  void splashTimer({required BuildContext context}) {
    Timer(
      const Duration(seconds: 3),
      () async {
        bool hasSession = await loginController.checkSession();
        if (hasSession) {
          log("Already User exit : ${PrefsService.prefs.getString("accessTokenKey")}");
          if (!context.mounted) return;
          AppNavigation().pushNamedRemoveUntil(
            context: context,
            route: AppRouteConstants.homeRoute,
          );
        } else {
          log("User doesn't exit");
          if (!context.mounted) return;
          AppNavigation().pushNamedRemoveUntil(
            context: context,
            route: AppRouteConstants.loginRoute,
          );
        }
      },
    );
  }
}
