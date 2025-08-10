import 'package:marshal_test_app/modules/home/data/models/get_recipe_details.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_model.dart';

class HomeEntity {
  final List<String> titles;
  final int selectedIndex;
  final bool isDeviceLoading;
  final Map<String, dynamic>? deviceInfo;
  final bool isRecipeLoading;
  final bool isRecipeDetailsLoading;
  final GetRecipeModel? recipeList;
  final GetRecipeDetailsModel? recipeDetailsList;

  const HomeEntity({
    required this.titles,
    required this.selectedIndex,
    required this.isDeviceLoading,
    required this.deviceInfo,
    required this.isRecipeLoading,
    required this.isRecipeDetailsLoading,
    required this.recipeList,
    required this.recipeDetailsList,
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
      isRecipeLoading: false,
      isRecipeDetailsLoading: false,
      recipeList: GetRecipeModel(),
      recipeDetailsList: GetRecipeDetailsModel(),
    );
  }

  /// CopyWith method for immutability
  HomeEntity copyWith({
    List<String>? titles,
    int? selectedIndex,
    bool? isDeviceLoading,
    Map<String, dynamic>? deviceInfo,
    bool? isRecipeLoading,
    bool? isRecipeDetailsLoading,
    GetRecipeModel? recipeList,
    GetRecipeDetailsModel? recipeDetailsList,
  }) {
    return HomeEntity(
      titles: titles ?? this.titles,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isDeviceLoading: isDeviceLoading ?? this.isDeviceLoading,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      isRecipeLoading: isRecipeLoading ?? this.isRecipeLoading,
      isRecipeDetailsLoading: isRecipeDetailsLoading ?? this.isRecipeDetailsLoading,
      recipeList: recipeList ?? this.recipeList,
      recipeDetailsList: recipeDetailsList ?? this.recipeDetailsList,
    );
  }
}
