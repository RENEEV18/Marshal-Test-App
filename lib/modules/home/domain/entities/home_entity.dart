class HomeEntity {
  final List<String> titles;
  final int selectedIndex;
  final bool isDeviceLoading;
  final Map<String, dynamic>? deviceInfo;

  const HomeEntity({
    required this.titles,
    required this.selectedIndex,
    required this.isDeviceLoading,
    required this.deviceInfo,
  });

  /// Initial/default state
  factory HomeEntity.initial() {
    return HomeEntity(
      titles: [
        "Profile",
        "Device & App deviceInfo",
        "Pick & Display Image",
        "Recipes",
        "Logout",
      ],
      selectedIndex: 0,
      isDeviceLoading: true,
      deviceInfo: {},
    );
  }

  /// CopyWith method for immutability
  HomeEntity copyWith({
    List<String>? titles,
    int? selectedIndex,
    bool? isDeviceLoading,
    Map<String, dynamic>? deviceInfo,
  }) {
    return HomeEntity(
      titles: titles ?? this.titles,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isDeviceLoading: isDeviceLoading ?? this.isDeviceLoading,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}
