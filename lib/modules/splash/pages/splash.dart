import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/images/images.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/loader.dart';
import 'package:marshal_test_app/modules/splash/controllers/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<SplashController>(context, listen: false).splashTimer(context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPadding.scaffoldPadding,
              child: Column(
                spacing: 20,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          AppImages.splashImage,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CommonLoadingWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
