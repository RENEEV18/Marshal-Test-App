import 'package:flutter/material.dart';
import 'package:marshal_test_app/modules/auth/data/models/login_response_model.dart';

class AuthEntity {
  final bool isLoginLoading;
  final LoginResponseModel loginList;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isUsername;
  final bool isPassword;

  const AuthEntity({
    required this.isLoginLoading,
    required this.loginList,
    required this.usernameController,
    required this.passwordController,
    required this.isUsername,
    required this.isPassword,
  });

  /// Initial/default state
  factory AuthEntity.initial() {
    return AuthEntity(
      isLoginLoading: false,
      loginList: LoginResponseModel(),
      usernameController: TextEditingController(),
      passwordController: TextEditingController(),
      isUsername: false,
      isPassword: false,
    );
  }

  /// CopyWith method for immutability
  AuthEntity copyWith({
    bool? isLoginLoading,
    LoginResponseModel? loginList,
    TextEditingController? usernameController,
    TextEditingController? passwordController,
    bool? isUsername,
    bool? isPassword,
  }) {
    return AuthEntity(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      loginList: loginList ?? this.loginList,
      usernameController: usernameController ?? this.usernameController,
      passwordController: passwordController ?? this.passwordController,
      isUsername: isUsername ?? this.isUsername,
      isPassword: isPassword ?? this.isPassword,
    );
  }
}
