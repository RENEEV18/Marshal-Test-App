class HomeEntity {
  final List<String> titles;
  final int selectedIndex;

  const HomeEntity({
    required this.titles,
    required this.selectedIndex,
  });

  /// Initial/default state
  factory HomeEntity.initial() {
    return HomeEntity(
      titles: [
        "Profile",
        "Device & App Info",
        "Pick & Display Image",
        "Recipes",
        "Logout",
      ],
      selectedIndex: 0,
    );
  }

  /// CopyWith method for immutability
  HomeEntity copyWith({
    List<String>? titles,
    int? selectedIndex,
  }) {
    return HomeEntity(
      titles: titles ?? this.titles,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
