import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.suffix,
    this.controller,
    required this.validator,
    this.obscureText,
    required this.keyboard,
    this.onChanged,
    this.text,
    this.contentPadding,
    this.preffix,
    this.hintText,
    this.colorFill,
    this.label,
    this.borderColor,
    this.focusBorderColor,
    this.enabledBorderColor,
    this.cursorColor,
    this.color,
    this.hintStyle,
    this.borderRadius,
    this.focussedBorderRadius,
    this.enabledBorderRadius,
    this.filled,
    this.inputFormatters,
    this.decoration,
    this.autovalidateMode,
    this.readOnly = false,
    this.fontSize,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.textfieldOpacity,
  });

  final Widget? suffix;
  final Widget? preffix;
  final String? hintText;
  final Color? colorFill;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final bool? obscureText;
  final String? text;
  final TextInputType keyboard;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;
  final Widget? label;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? enabledBorderColor;
  final Color? cursorColor;
  final Color? color;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final BorderRadius? focussedBorderRadius;
  final BorderRadius? enabledBorderRadius;
  final bool? filled;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final double? fontSize;
  final void Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final double? textfieldOpacity;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: textfieldOpacity ?? 1,
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText ?? false,
        keyboardType: keyboard,
        textInputAction: TextInputAction.done,
        controller: controller,
        cursorColor: cursorColor ?? AppColors.primaryBlack,
        style: TextStyle(color: color ?? AppColors.primaryBlack, fontSize: fontSize ?? 16),
        validator: validator,
        inputFormatters: inputFormatters,
        autovalidateMode: autovalidateMode,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        minLines: minLines,
        decoration: decoration ??
            InputDecoration(
              fillColor: colorFill,
              suffixIcon: suffix,
              hintText: hintText,
              hintStyle: hintStyle ??
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: AppColors.primaryBlack.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w300,
                      ),
              prefixIcon: preffix,
              filled: filled,
              label: (text != null || label != null)
                  ? label ??
                      Text(
                        text ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: AppColors.primaryBlack.withValues(alpha: 0.4),
                              fontWeight: FontWeight.w300,
                            ),
                      )
                  : null,
              contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor ?? AppColors.primaryBlack.withValues(alpha: 0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: enabledBorderColor ?? AppColors.primaryBlack.withValues(alpha: 0.2)),
                borderRadius: enabledBorderRadius ?? BorderRadius.circular(14),
              ),
              enabled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: focusBorderColor ?? AppColors.primaryBlack.withValues(alpha: 0.2)),
                borderRadius: focussedBorderRadius ?? BorderRadius.circular(14),
              ),
            ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    this.backgroundColor,
    this.borderRadius,
    this.style,
    this.padding,
    this.onPressed,
    this.isLoading = false,
    this.side,
    this.foregroundColor,
    this.opacity,
  });

  final String text;
  final WidgetStateProperty<Color?>? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? style;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;
  final void Function()? onPressed;
  final bool isLoading;
  final BorderSide? side;
  final WidgetStateProperty<Color?>? foregroundColor;
  final double? opacity;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity ?? 1,
      child: AbsorbPointer(
        absorbing: opacity == 0.3 ? true : false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: backgroundColor,
              padding: padding ??
                  WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  ),
              foregroundColor: foregroundColor ?? WidgetStateProperty.all(AppColors.primaryWhite),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(14), side: side ?? BorderSide.none),
              ),
            ),
            child: isLoading
                ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2),
                    child: const CircularProgressIndicator(color: AppColors.primaryWhite, strokeWidth: 2),
                  )
                : FittedBox(fit: BoxFit.scaleDown, child: Text(text, style: style)),
          ),
        ),
      ),
    );
  }
}

class CommonTwoHeaderColumnTileWidget extends StatelessWidget {
  const CommonTwoHeaderColumnTileWidget({
    super.key,
    required this.headerTitle,
    required this.subWidget,
    this.headerStyle,
    this.spaceWidget,
  });
  final String headerTitle;
  final Widget subWidget;
  final TextStyle? headerStyle;
  final Widget? spaceWidget;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerTitle,
          style: headerStyle,
        ),
        spaceWidget ?? AppStyle.kHeight10,
        subWidget,
      ],
    );
  }
}
