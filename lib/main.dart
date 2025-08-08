import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/utils/provider_setup.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';
import 'package:marshal_test_app/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderSetup().getProviders(),
      child: MaterialApp(
        title: 'Marshal Test App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.primaryWhite,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,
            brightness: Brightness.light,
          ),
        ),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
