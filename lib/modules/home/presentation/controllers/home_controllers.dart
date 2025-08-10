import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/services/method_channel_service.dart';
import 'package:marshal_test_app/core/utils/errors/error.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';
import 'package:marshal_test_app/core/utils/snackbar.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_details.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_model.dart';
import 'package:marshal_test_app/modules/home/data/repositories/home_repo_impl.dart';
import 'package:marshal_test_app/modules/home/domain/entities/home_entity.dart';
import 'package:marshal_test_app/modules/home/domain/repositories/home_repo.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/device_info_page/device_info_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/pick_image_page/pick_image_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/profile_page/profile_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/recipes_page/recipes_page.dart';
import 'package:marshal_test_app/routes/route_constants.dart';

class HomeController extends ChangeNotifier {
  final HomeRepo _homeRepo = HomeRepoImpl();
  HomeEntity _state = HomeEntity.initial();
  HomeEntity get state => _state;
  Timer? _searchDebounce;
  // Private helper to update state
  void updateState(HomeEntity newState) {
    _state = newState;
    notifyListeners();
  }

  // Common error handler for all auth functions
  void _handleError(BuildContext context, dynamic error) {
    if (!context.mounted) return;

    if (error is ApiException) {
      AppSnackbar.show(context, message: error.message, type: error.type);
    } else {
      AppSnackbar.show(
        context,
        message: "Something went wrong!",
        type: SnackbarType.error,
      );
    }
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
  void changePageIndex({required BuildContext context, required int index}) async {
    if (index != 4) {
      updateState(
        _state.copyWith(selectedIndex: index),
      );
      AppNavigation().pop(context: context);
    } else {
      await PrefsService.clearAll();
      if (!context.mounted) return;
      AppNavigation().pushNamedRemoveUntil(context: context, route: AppRouteConstants.loginRoute);
    }
  }

  // Function to update search query
  void updateSearchQuery(String query) {
    updateState(_state.copyWith(searchQuery: query, skip: 0));
  }

  // Function to update skip (pagination)
  void updateSkip(int value) {
    updateState(_state.copyWith(skip: value));
  }

  // Method Channel Functions----------------
  // Function for fetching device info
  Future<void> getDeviceInfo() async {
    final info = await MethodChannelService.getDeviceInfo();
    updateState(
      _state.copyWith(
        isDeviceLoading: false,
        deviceInfo: info,
      ),
    );
  }

  // Image Picker Module Functions----------------
  // Function to pick the image
  Future<void> pickImageFromGallery(BuildContext context) async {
    final path = await MethodChannelService.pickImage();
    if (path != null && path.isNotEmpty) {
      updateState(_state.copyWith(selectedImagePath: path));
    }
  }

  // Function to clear the image
  void clearImage() {
    updateState(_state.copyWith(selectedImagePath: null));
  }

  // Recipe Module Functions----------------
  // Controller function to get all recipe
  Future<void> getAllRecipe({
    required BuildContext context,
    required int limit,
    int skip = 0,
    String searchQuery = "",
    bool isLoadMore = false,
  }) async {
    try {
      updateState(_state.copyWith(isRecipeLoading: true));

      // Logic for pagination & api call based on the limit (pages).
      final newData = searchQuery.isNotEmpty
          ? await _homeRepo.searchRecipeRepo(query: searchQuery, limit: limit, skip: skip)
          : await _homeRepo.getRecipeRepo(limit: limit, skip: skip);

      // Local tag & meal filtering
      final filteredRecipes = (newData.recipes ?? []).where((recipe) {
        final matchesTags = _state.selectedTags.isEmpty || recipe.tags!.any((tag) => _state.selectedTags.contains(tag));
        final matchesMeal =
            _state.selectedMeals.isEmpty || recipe.mealType!.any((meal) => _state.selectedMeals.contains(meal));
        return matchesTags && matchesMeal;
      }).toList();

      if (isLoadMore && _state.recipeList != null) {
        final List<Recipe> currentRecipes = List.of(_state.recipeList?.recipes ?? []);
        currentRecipes.addAll(filteredRecipes);

        updateState(
          _state.copyWith(
            recipeList: _state.recipeList!.copyWith(
              recipes: currentRecipes,
            ),
            isRecipeLoading: false,
          ),
        );
      } else {
        updateState(
          _state.copyWith(
            recipeList: _state.recipeList!.copyWith(
              recipes: filteredRecipes,
            ),
            isRecipeLoading: false,
          ),
        );
      }

      log("Api Success: ${state.recipeList}");
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(_state.copyWith(isRecipeLoading: false));
    }
  }

  // Controller function to get recipe details
  Future<void> getRecipeDetails({required BuildContext context, required int id}) async {
    updateState(
      _state.copyWith(
        isRecipeDetailsLoading: true,
      ),
    );
    try {
      await _homeRepo
          .getRecipeDetailsRepo(
        recipeId: id,
      )
          .then(
        (value) {
          updateState(
            _state.copyWith(
              isRecipeDetailsLoading: false,
              recipeDetailsList: value,
            ),
          );
          log("Api Success : $value");
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(
        _state.copyWith(isRecipeDetailsLoading: false),
      );
    }
  }

  // Temporary filter state
  List<String> tempSelectedTags = [];
  List<String> tempSelectedMeals = [];

  void initTempFilters() {
    tempSelectedTags = List.from(_state.selectedTags);
    tempSelectedMeals = List.from(_state.selectedMeals);
  }

  void toggleTempTag(String tag) {
    if (tempSelectedTags.contains(tag)) {
      tempSelectedTags.remove(tag);
    } else {
      tempSelectedTags.add(tag);
    }
    notifyListeners();
  }

  void toggleTempMeal(String meal) {
    if (tempSelectedMeals.contains(meal)) {
      tempSelectedMeals.remove(meal);
    } else {
      tempSelectedMeals.add(meal);
    }
    notifyListeners();
  }

  void applyTempFilters() {
    _state = _state.copyWith(
      selectedTags: List.from(tempSelectedTags),
      selectedMeals: List.from(tempSelectedMeals),
    );
    notifyListeners();
  }

  void clearTempFilters() {
    tempSelectedTags.clear();
    tempSelectedMeals.clear();
    notifyListeners();
  }

  // Function to update the recipe
  void toggleEditMode() {
    updateState(_state.copyWith(isEditMode: !_state.isEditMode));
  }

  Future<void> updateRecipe({
    required BuildContext context,
    required int recipeId,
    required Map<String, dynamic> body,
  }) async {
    updateState(_state.copyWith(isRecipeUpdateLoading: true));
    try {
      final updated = await _homeRepo.updateRecipeRepo(recipeId: recipeId, body: body);

      updateState(_state.copyWith(
        recipeDetailsList: updated,
        isRecipeUpdateLoading: false,
        isEditMode: false,
      ));
      if (!context.mounted) return;

      AppSnackbar.show(context, message: "Recipe updated successfully!", type: SnackbarType.success);
      clearEditRecipeForm();
      getAllRecipe(
        context: context,
        limit: state.limit,
        skip: state.skip,
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(_state.copyWith(isRecipeUpdateLoading: false));
    }
  }

  void onSearchChanged(BuildContext context, String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      updateSearchQuery(query.trim());
      updateSkip(0);
      log("query : $query");
      getAllRecipe(
        context: context,
        limit: _state.limit,
        skip: 0,
        searchQuery: _state.searchQuery,
      );
    });
  }

  // Add new ingredient field
  void addIngredientField() {
    final updatedControllers = List<TextEditingController>.from(_state.ingredientControllers)
      ..add(TextEditingController());

    updateState(
      _state.copyWith(ingredientControllers: updatedControllers),
    );
  }

// Remove ingredient field by index
  void removeIngredientField(int index) {
    final updatedControllers = List<TextEditingController>.from(_state.ingredientControllers);
    updatedControllers[index].dispose();
    updatedControllers.removeAt(index);

    updateState(
      _state.copyWith(ingredientControllers: updatedControllers),
    );
  }

// Populate controllers from API model
  void populateRecipeDetails(GetRecipeDetailsModel? model) {
    final nameCtrl = _state.nameController..text = model?.name ?? '';
    final prepCtrl = _state.prepController..text = model?.prepTimeMinutes?.toString() ?? '';
    final servingsCtrl = _state.servingsController..text = model?.servings?.toString() ?? '';

    // Dispose old ingredient controllers
    for (final controllers in _state.ingredientControllers) {
      controllers.dispose();
    }

    // Create new list of controllers
    final ingredientsList = (model?.ingredients ?? []);
    final newIngredientControllers = ingredientsList.isNotEmpty
        ? ingredientsList.map((ing) => TextEditingController(text: ing)).toList()
        : [TextEditingController()];

    updateState(
      _state.copyWith(
        nameController: nameCtrl,
        prepController: prepCtrl,
        servingsController: servingsCtrl,
        ingredientControllers: newIngredientControllers,
      ),
    );
  }

  Future<void> saveRecipe(BuildContext context, int recipeId) async {
    final ingredients = _state.ingredientControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

    final body = <String, dynamic>{
      "name": _state.nameController.text.trim(),
      "ingredients": ingredients,
      "prepTimeMinutes": int.tryParse(_state.prepController.text.trim()) ?? 0,
      "servings": int.tryParse(_state.servingsController.text.trim()) ?? 0,
    };

    await updateRecipe(
      context: context,
      recipeId: recipeId,
      body: body,
    );
  }

  void initAddRecipeForm() {
    // copy existing controllers (they already are in the entity)
    updateState(_state.copyWith(
      addNameController: _state.addNameController..text = '',
      addPrepController: _state.addPrepController..text = '',
      addCookController: _state.addCookController..text = '',
      addServingsController: _state.addServingsController..text = '',
      addCaloriesController: _state.addCaloriesController..text = '',
      addCuisineController: _state.addCuisineController..text = '',
      addDifficultyController: _state.addDifficultyController..text = '',
      addTagsController: _state.addTagsController..text = '',
      addImageController: _state.addImageController..text = '',
      addIngredientControllers: [TextEditingController()],
      addInstructionControllers: [TextEditingController()],
      addSelectedMeals: [],
    ));
  }

  void clearAddRecipeForm() {
    // dispose controllers safely
    for (final controller in _state.addIngredientControllers) {
      controller.dispose();
    }
    for (final controller in _state.addInstructionControllers) {
      controller.dispose();
    }

    updateState(_state.copyWith(
      addNameController: TextEditingController(),
      addPrepController: TextEditingController(),
      addCookController: TextEditingController(),
      addServingsController: TextEditingController(),
      addCaloriesController: TextEditingController(),
      addCuisineController: TextEditingController(),
      addDifficultyController: TextEditingController(),
      addTagsController: TextEditingController(),
      addImageController: TextEditingController(),
      addIngredientControllers: [TextEditingController()],
      addInstructionControllers: [TextEditingController()],
      addSelectedMeals: [],
    ));
  }

  void addRecipeIngredientField() {
    final updated = List<TextEditingController>.from(_state.addIngredientControllers)..add(TextEditingController());
    updateState(_state.copyWith(addIngredientControllers: updated));
  }

  void removeRecipeIngredientField(int index) {
    final updated = List<TextEditingController>.from(_state.addIngredientControllers);
    updated[index].dispose();
    updated.removeAt(index);
    updateState(_state.copyWith(addIngredientControllers: updated));
  }

  void addInstructionField() {
    final updated = List<TextEditingController>.from(_state.addInstructionControllers)..add(TextEditingController());
    updateState(_state.copyWith(addInstructionControllers: updated));
  }

  void removeInstructionField(int index) {
    final updated = List<TextEditingController>.from(_state.addInstructionControllers);
    updated[index].dispose();
    updated.removeAt(index);
    updateState(_state.copyWith(addInstructionControllers: updated));
  }

  void toggleAddMealType(String meal) {
    final updated = List<String>.from(_state.addSelectedMeals);
    if (updated.contains(meal)) {
      updated.remove(meal);
    } else {
      updated.add(meal);
    }
    updateState(_state.copyWith(addSelectedMeals: updated));
  }

  void clearEditRecipeForm() {
    // Dispose existing ingredient controllers
    for (final controller in _state.ingredientControllers) {
      controller.dispose();
    }

    updateState(_state.copyWith(
      nameController: TextEditingController(),
      prepController: TextEditingController(),
      servingsController: TextEditingController(),
      ingredientControllers: [TextEditingController()],
    ));
  }

  // Build request body from add-form controllers
  Map<String, dynamic> _buildAddRecipeBody() {
    final ingredients = _state.addIngredientControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    final instructions = _state.addInstructionControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    final tags = _state.addTagsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    return {
      "name": _state.addNameController.text.trim(),
      "ingredients": ingredients,
      "instructions": instructions,
      "prepTimeMinutes": int.tryParse(_state.addPrepController.text.trim()) ?? 0,
      "cookTimeMinutes": int.tryParse(_state.addCookController.text.trim()) ?? 0,
      "servings": int.tryParse(_state.addServingsController.text.trim()) ?? 0,
      "difficulty": _state.addDifficultyController.text.trim(),
      "cuisine": _state.addCuisineController.text.trim(),
      "caloriesPerServing": int.tryParse(_state.addCaloriesController.text.trim()) ?? 0,
      "tags": tags,
      "image": _state.addImageController.text.trim(),
      "mealType": _state.addSelectedMeals,
    };
  }

  // Function to add recipe
  Future<void> addRecipe({required BuildContext context}) async {
    updateState(_state.copyWith(isRecipeAddLoading: true));
    try {
      final body = _buildAddRecipeBody();
      final added = await _homeRepo.addRecipeRepo(body: body);

      // Option 1: Insert the new recipe into current recipeList (if present)
      final currentRecipes = List<Recipe>.from(_state.recipeList?.recipes ?? []);
      currentRecipes.insert(0, Recipe.fromJson(added.toJson())); // convert details->recipe (if needed)

      updateState(_state.copyWith(
        recipeList: _state.recipeList?.copyWith(recipes: currentRecipes) ?? _state.recipeList,
        isRecipeAddLoading: false,
      ));

      if (!context.mounted) return;
      AppSnackbar.show(context, message: "Recipe added", type: SnackbarType.success);
      AppNavigation().pop(context: context);
      clearAddRecipeForm();
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(_state.copyWith(isRecipeAddLoading: false));
    }
  }

  // Function to Delete recipe  ----------
  Future<void> deleteRecipe({required BuildContext context, required int recipeId}) async {
    updateState(_state.copyWith(isRecipeDeleteLoading: true));
    try {
      await _homeRepo.deleteRecipeRepo(recipeId: recipeId);

      // Remove from current list if present
      final updatedList = List<Recipe>.from(_state.recipeList?.recipes ?? []);
      updatedList.removeWhere((r) => r.id == recipeId);

      updateState(_state.copyWith(
        recipeList: _state.recipeList?.copyWith(recipes: updatedList),
        isRecipeDeleteLoading: false,
      ));

      if (!context.mounted) return;
      AppSnackbar.show(context, message: "Recipe deleted", type: SnackbarType.success);
      AppNavigation().pop(context: context);
      getAllRecipe(
        context: context,
        limit: state.limit,
        skip: state.skip,
      );
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      updateState(_state.copyWith(isRecipeDeleteLoading: false));
    }
  }

  void clearSearch(BuildContext context) {
    updateSearchQuery("");
    updateSkip(0);
    getAllRecipe(
      context: context,
      limit: _state.limit,
      skip: 0,
    );
  }
}
