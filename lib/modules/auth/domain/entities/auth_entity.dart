import 'package:flutter/material.dart';
import 'package:marshal_test_app/modules/auth/data/models/get_user_model.dart';

class AuthEntity {
  final bool isLoginLoading;
  final bool isUserLoading;
  final GetUserModel? getUserList;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isUsername;
  final bool isPassword;

  const AuthEntity({
    required this.isLoginLoading,
    required this.isUserLoading,
    required this.getUserList,
    required this.usernameController,
    required this.passwordController,
    required this.isUsername,
    required this.isPassword,
  });

  /// Initial/default state
  factory AuthEntity.initial() {
    return AuthEntity(
      isLoginLoading: false,
      isUserLoading: false,
      getUserList: GetUserModel(),
      usernameController: TextEditingController(),
      passwordController: TextEditingController(),
      isUsername: false,
      isPassword: false,
    );
  }

  /// CopyWith method for immutability
  AuthEntity copyWith({
    bool? isLoginLoading,
    bool? isUserLoading,
    GetUserModel? getUserList,
    TextEditingController? usernameController,
    TextEditingController? passwordController,
    bool? isUsername,
    bool? isPassword,
  }) {
    return AuthEntity(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      isUserLoading: isUserLoading ?? this.isUserLoading,
      getUserList: getUserList ?? this.getUserList,
      usernameController: usernameController ?? this.usernameController,
      passwordController: passwordController ?? this.passwordController,
      isUsername: isUsername ?? this.isUsername,
      isPassword: isPassword ?? this.isPassword,
    );
  }
}
