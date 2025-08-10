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

class LoadingTextWidget extends StatelessWidget {
  final String text;
  const LoadingTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonLoadingWidget(),
        Text(text),
      ],
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("No data found! Something went wrong"),
      ],
    );
  }
}
