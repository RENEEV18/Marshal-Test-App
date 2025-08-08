import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/images/images.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/textforms.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPadding.loginPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  AppStyle.kHeight20,
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    "Please enter log in details below",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  AppStyle.kHeight30,
                  CustomTextFormField(
                    text: "Enter your username",
                    validator: (val) {
                      return null;
                    },
                    keyboard: TextInputType.name,
                    onChanged: (val) {},
                  ),
                  AppStyle.kHeight20,
                  CustomTextFormField(
                    text: "Enter your password",
                    validator: (val) {
                      return null;
                    },
                    keyboard: TextInputType.visiblePassword,
                    onChanged: (val) {},
                  ),
                  AppStyle.kHeight30,
                  ButtonWidget(
                    text: 'LOGIN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                        ),
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.primaryColor,
                    ),
                    onPressed: () {},
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
