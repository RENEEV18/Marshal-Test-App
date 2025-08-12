import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
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
  void updateState(AuthEntity newState) {
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

  Icon icon = Icon(
    Icons.visibility_off_outlined,
    color: AppColors.primaryBlack.withValues(alpha: 0.6),
    size: 18,
  );

  // Controller function for login
  Future<void> loginFn({required BuildContext context}) async {
    updateState(
      _state.copyWith(
        isLoginLoading: true,
      ),
    );
    try {
      await _authRepo.loginRepo(body: {
        "username": HelperFunction.checkValue(state.usernameController.text),
        "password": HelperFunction.checkValue(state.passwordController.text),
      }).then(
        (value) {
          updateState(
            _state.copyWith(
              isLoginLoading: false,
            ),
          );
          log("Api Success : ${value.firstName}\nAccess Token : ${PrefsService.prefs.getString("accessTokenKey")}\nRefresh Token : ${PrefsService.prefs.getString("refreshTokenKey")}");
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Login successful!",
            type: SnackbarType.success,
          );
          state.usernameController.clear();
          state.passwordController.clear();
          updateState(_state.copyWith(
            obscureText: true,
          ));
          AppNavigation().pushNamedRemoveUntil(context: context, route: AppRouteConstants.homeRoute);
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(
        _state.copyWith(isLoginLoading: false),
      );
    }
  }

  // Controller function for getting user profile
  Future<void> getUserProfile({required BuildContext context}) async {
    updateState(
      _state.copyWith(
        isUserLoading: true,
      ),
    );
    try {
      await _authRepo.getUserRepo().then(
        (value) {
          updateState(
            _state.copyWith(
              isUserLoading: false,
              getUserList: value,
            ),
          );
          log("Api Success : $value");
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(
        _state.copyWith(isUserLoading: false),
      );
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
        updateState(_state.copyWith(isUsername: false));
      } else {
        updateState(_state.copyWith(isPassword: false));
      }
    } else {
      if (type == "username") {
        updateState(_state.copyWith(isUsername: true));
      } else {
        updateState(_state.copyWith(isPassword: true));
      }
    }
  }

  // Obscure Password Visibility
  void visibility() {
    updateState(_state.copyWith(
      obscureText: !_state.obscureText,
    ));
    icon = state.obscureText
        ? Icon(
            Icons.visibility_off_outlined,
            color: AppColors.primaryBlack.withValues(alpha: 0.6),
            size: 18,
          )
        : Icon(
            Icons.visibility_outlined,
            color: AppColors.primaryBlack.withValues(alpha: 0.6),
            size: 18,
          );
    notifyListeners();
    log("visibility : ${state.obscureText}");
  }
}
