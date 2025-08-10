import 'package:marshal_test_app/modules/auth/presentation/controllers/login_controller.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:marshal_test_app/modules/splash/controllers/splash_controller.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

class ProviderSetup {
  List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(
        create: (context) => SplashController(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginController(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeController(),
      ),
    ];
  }
}
