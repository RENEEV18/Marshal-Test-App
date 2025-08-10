import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/utils/widgets/listview.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final Color? borderColor;

  const ProfileInfoTile({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CommonListTile(
      elevation: 0,
      borderColor: borderColor ?? AppColors.primaryBlack.withValues(alpha: 0.04),
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      leading: CircleAvatar(
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 26,
        ),
      ),
      titleWidget: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      isSubtitle: true,
      subtitleWidget: Text(
        value.isNotEmpty ? value : "Not available",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
