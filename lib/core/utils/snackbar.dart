import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';

enum SnackbarType { success, error, warning }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
  }) {
    Color bgColor;
    switch (type) {
      case SnackbarType.success:
        bgColor = AppColors.primaryColor;
        break;
      case SnackbarType.error:
        bgColor = AppColors.primaryRed;
        break;
      case SnackbarType.warning:
        bgColor = AppColors.primaryOrange;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.primaryWhite,
          ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
