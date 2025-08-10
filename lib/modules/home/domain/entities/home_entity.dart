import 'package:flutter/material.dart';
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
  final List<String> selectedTags;
  final List<String> selectedMeals;
  final String searchQuery;
  final int skip;
  final int limit;
  final List<String> allMeals;
  final List<String> allTags;
  final bool isRecipeUpdateLoading;
  final bool isEditMode;
  final String? selectedImagePath;
  final TextEditingController nameController;
  final TextEditingController prepController;
  final TextEditingController servingsController;
  final List<TextEditingController> ingredientControllers;
  const HomeEntity({
    required this.titles,
    required this.selectedIndex,
    required this.isDeviceLoading,
    required this.deviceInfo,
    required this.isRecipeLoading,
    required this.isRecipeDetailsLoading,
    required this.recipeList,
    required this.recipeDetailsList,
    required this.selectedTags,
    required this.selectedMeals,
    required this.searchQuery,
    required this.skip,
    required this.limit,
    required this.allMeals,
    required this.allTags,
    required this.isRecipeUpdateLoading,
    required this.isEditMode,
    required this.selectedImagePath,
    required this.nameController,
    required this.prepController,
    required this.servingsController,
    required this.ingredientControllers,
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
      selectedTags: [],
      selectedMeals: [],
      searchQuery: "",
      skip: 0,
      limit: 10,
      allMeals: ["Breakfast", "Lunch", "Dinner", "Snack"],
      allTags: ["Vegetarian", "Vegan", "Gluten-Free", "Spicy", "Quick"],
      isRecipeUpdateLoading: false,
      isEditMode: false,
      selectedImagePath: null,
      nameController: TextEditingController(),
      prepController: TextEditingController(),
      servingsController: TextEditingController(),
      ingredientControllers: [TextEditingController()],
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
    List<String>? selectedTags,
    List<String>? selectedMeals,
    String? searchQuery,
    int? skip,
    int? limit,
    List<String>? allMeals,
    List<String>? allTags,
    bool? isRecipeUpdateLoading,
    bool? isEditMode,
    String? selectedImagePath,
    TextEditingController? nameController,
    TextEditingController? prepController,
    TextEditingController? servingsController,
    List<TextEditingController>? ingredientControllers,
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
      selectedTags: selectedTags ?? this.selectedTags,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      searchQuery: searchQuery ?? this.searchQuery,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      allMeals: allMeals ?? this.allMeals,
      allTags: allTags ?? this.allTags,
      isRecipeUpdateLoading: isRecipeUpdateLoading ?? this.isRecipeUpdateLoading,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      nameController: nameController ?? this.nameController,
      prepController: prepController ?? this.prepController,
      servingsController: servingsController ?? this.servingsController,
      ingredientControllers: ingredientControllers ?? this.ingredientControllers,
    );
  }
}
