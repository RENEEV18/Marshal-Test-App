import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/services/method_channel_service.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/modules/home/domain/entities/home_entity.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/device_info_page/device_info_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/pick_image_page/pick_image_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/profile_page/profile_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/recipes_page/recipes_page.dart';

class HomeControllers extends ChangeNotifier {
  HomeEntity _state = HomeEntity.initial();
  HomeEntity get state => _state;

  // Private helper to update state
  void _updateState(HomeEntity newState) {
    _state = newState;
    notifyListeners();
  }

  // List of pages to show in Homepage
  final List<Widget> pages = const [
    ProfilePage(),
    DeviceInfoPage(),
    PickImagePage(),
    RecipesPage(),
  ];

  // List of icons to show in Drawer
  final List<IconData> drawerIcons = const [
    Icons.person,
    Icons.devices,
    Icons.image,
    Icons.fastfood,
    Icons.logout,
  ];

  // Function to change the page index.
  void changePageIndex({required BuildContext context, required int index}) {
    _updateState(
      _state.copyWith(selectedIndex: index),
    );
    AppNavigation().pop(context: context);
  }

  // Method Channel Functions----------------
  // Function for fetching device info
  Future<void> getDeviceInfo() async {
    final info = await MethodChannelService.getDeviceInfo();
    _updateState(
      _state.copyWith(
        isDeviceLoading: false,
        deviceInfo: info,
      ),
    );
  }
}
