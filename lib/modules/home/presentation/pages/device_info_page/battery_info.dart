import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/services/method_channel_service.dart';

class BatteryInfo extends StatelessWidget {
  const BatteryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: MethodChannelService.getBatteryInfo(),
      initialData: -1,
      builder: (context, snapshot) {
        final level = snapshot.data ?? -1;
        if (level < 0) return SizedBox.shrink();
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.battery_std, color: AppColors.primaryWhite, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$level%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
