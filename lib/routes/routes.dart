import 'package:flutter/material.dart';
import 'package:marshal_test_app/modules/auth/presentation/pages/login.dart';
import 'package:marshal_test_app/modules/splash/pages/splash.dart';
import 'package:marshal_test_app/routes/route_constants.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // App Routes for splash
      case AppRouteConstants.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      // App Routes for login
      case AppRouteConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      // App Routes for default
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
