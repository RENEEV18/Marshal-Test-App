import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/images/images.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/widgets/textforms.dart';
import 'package:marshal_test_app/modules/auth/presentation/controllers/login_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(builder: (context, value, child) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: AppPadding.loginPadding,
                child: Form(
                  key: formKey,
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
                              fontSize: 24,
                            ),
                      ),
                      Text(
                        "Please enter account details below",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      AppStyle.kHeight30,
                      CustomTextFormField(
                        text: "Username",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: value.state.usernameController,
                        validator: (val) {
                          return value.authValidator(value: val, type: "username");
                        },
                        keyboard: TextInputType.name,
                        onChanged: (val) {
                          value.onAuthFieldChange(value: val, type: "username");
                        },
                      ),
                      AppStyle.kHeight20,
                      CustomTextFormField(
                        text: "Password",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        suffix: IconButton(
                            onPressed: () {
                              value.visibility();
                            },
                            icon: value.icon),
                        obscureText: value.state.obscureText,
                        controller: value.state.passwordController,
                        validator: (val) {
                          return value.authValidator(value: val, type: "password");
                        },
                        keyboard: TextInputType.visiblePassword,
                        onChanged: (val) {
                          value.onAuthFieldChange(value: val, type: "password");
                        },
                      ),
                      AppStyle.kHeight30,
                      Opacity(
                        opacity: value.state.isUsername && value.state.isPassword ? 1 : 0.4,
                        child: ButtonWidget(
                          isLoading: value.state.isLoginLoading,
                          text: 'LOGIN',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryWhite,
                              ),
                          backgroundColor: const WidgetStatePropertyAll(
                            AppColors.primaryColor,
                          ),
                          onPressed: value.state.isUsername && value.state.isPassword
                              ? () {
                                  value.loginFn(context: context);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
