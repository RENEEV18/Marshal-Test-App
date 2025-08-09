import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({super.key, this.circleColor, this.circleValue});
  final Color? circleColor;
  final double? circleValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: circleColor ?? AppColors.primaryColor,
        strokeWidth: 2.5,
        value: circleValue,
      ),
    );
  }
}
