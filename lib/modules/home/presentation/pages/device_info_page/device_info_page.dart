import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/widgets/listview.dart';
import 'package:marshal_test_app/core/utils/widgets/loader.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:marshal_test_app/modules/home/presentation/widgets/profile_tile.dart';
import 'package:provider/provider.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false).getDeviceInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        if (home.state.isDeviceLoading) {
          return const Center(
            child: CommonLoadingWidget(),
          );
        }

        final info = home.state.deviceInfo;
        if (info == null || info.isEmpty) {
          return const Center(
            child: Text('No info found!'),
          );
        }

        final items = [
          {
            "icon": Icons.phone_android,
            "label": "Model",
            "value": info["model"]?.toString() ?? "",
          },
          {
            "icon": Icons.business,
            "label": "Manufacturer",
            "value": info["manufacturer"]?.toString() ?? "",
          },
          {
            "icon": Icons.android,
            "label": "Android Version",
            "value": info["androidVersion"]?.toString() ?? "",
          },
          {
            "icon": Icons.code,
            "label": "SDK Int",
            "value": info["sdkInt"]?.toString() ?? "",
          },
          {
            "icon": Icons.app_settings_alt,
            "label": "App Version",
            "value": info["appVersion"]?.toString() ?? "",
          },
          {
            "icon": Icons.assignment,
            "label": "Package Name",
            "value": info["packageName"]?.toString() ?? "",
          },
        ];

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: CommonListviewBuilder(
            separatorBuilder: (context, index) {
              return AppStyle.kHeight15;
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ProfileInfoTile(
                icon: item["icon"] as IconData,
                label: item["label"] as String,
                value: item["value"] as String,
              );
            },
          ),
        );
      },
    );
  }
}
