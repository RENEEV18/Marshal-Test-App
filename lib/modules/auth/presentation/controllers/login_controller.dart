import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/utils/errors/error.dart';
import 'package:marshal_test_app/core/utils/formatter.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';
import 'package:marshal_test_app/core/utils/snackbar.dart';
import 'package:marshal_test_app/modules/auth/data/repositories/auth_repo_impl.dart';
import 'package:marshal_test_app/modules/auth/domain/entities/auth_entity.dart';
import 'package:marshal_test_app/modules/auth/domain/repositories/auth_repo.dart';
import 'package:marshal_test_app/routes/route_constants.dart';

class LoginController extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepoImpl();
  AuthEntity _state = AuthEntity.initial();
  AuthEntity get state => _state;

  // Private helper to update state
  void _updateState(AuthEntity newState) {
    _state = newState;
    notifyListeners();
  }

  /// Common error handler for all auth functions
  void _handleError(BuildContext context, dynamic error) {
    if (!context.mounted) return;

    if (error is ApiException) {
      AppSnackbar.show(context, message: error.message, type: error.type);
    } else {
      AppSnackbar.show(
        context,
        message: "Something went wrong!",
        type: SnackbarType.error,
      );
    }
  }

  // Controller function for login
  Future<void> loginFn({required BuildContext context}) async {
    _state = _state.copyWith(
      isLoginLoading: true,
    );
    notifyListeners();
    try {
      await _authRepo.loginRepo(body: {
        "username": HelperFunction.checkValue(state.usernameController.text),
        "password": HelperFunction.checkValue(state.passwordController.text),
      }).then(
        (value) {
          _state = _state.copyWith(
            isLoginLoading: false,
            loginList: value,
          );
          log("Api Success : ${state.loginList}\nAccess Token : ${PrefsService.prefs.getString("accessTokenKey")}\nRefresh Token : ${PrefsService.prefs.getString("refreshTokenKey")}");
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Login successful!",
            type: SnackbarType.success,
          );
          AppNavigation().pushNamedRemoveUntil(context: context, route: AppRouteConstants.homeRoute);
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      _updateState(_state.copyWith(isLoginLoading: false));
      notifyListeners();
    }
  }

  // Function to check the session
  Future<bool> checkSession() async {
    final tokens = await _authRepo.getTokens();
    return tokens["accessToken"] != null && tokens["accessToken"]!.isNotEmpty;
  }

  // Function for the validation for username & password
  String? authValidator({required String? value, required String type}) {
    if (value == null || value.isEmpty) {
      return type == "username" ? 'Username is required' : 'Password is required';
    }
    return null;
  }

  void onAuthFieldChange({required String? value, required String type}) {
    if (value == null || value.isEmpty) {
      if (type == "username") {
        _state = _state.copyWith(isUsername: false);
      } else {
        _state = _state.copyWith(isPassword: false);
      }
    } else {
      if (type == "username") {
        _state = _state.copyWith(isUsername: true);
      } else {
        _state = _state.copyWith(isPassword: true);
      }
    }
    notifyListeners();
  }
}
