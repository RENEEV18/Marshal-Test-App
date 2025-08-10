import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';

class CommonContainerWithBorder extends StatelessWidget {
  const CommonContainerWithBorder({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.borderColor,
    this.radius,
  });
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        color: color ?? AppColors.primaryWhite,
        border: Border.all(
          color: borderColor ?? AppColors.primaryBlack.withAlpha((0.1 * 255).round()),
        ),
      ),
      child: child,
    );
  }
}
