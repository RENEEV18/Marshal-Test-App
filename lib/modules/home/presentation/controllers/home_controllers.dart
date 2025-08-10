import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/services/method_channel_service.dart';
import 'package:marshal_test_app/core/utils/errors/error.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/snackbar.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_model.dart';
import 'package:marshal_test_app/modules/home/data/repositories/home_repo_impl.dart';
import 'package:marshal_test_app/modules/home/domain/entities/home_entity.dart';
import 'package:marshal_test_app/modules/home/domain/repositories/home_repo.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/device_info_page/device_info_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/pick_image_page/pick_image_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/profile_page/profile_page.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/recipes_page/recipes_page.dart';

class HomeController extends ChangeNotifier {
  final HomeRepo _homeRepo = HomeRepoImpl();
  HomeEntity _state = HomeEntity.initial();
  HomeEntity get state => _state;

  // Private helper to update state
  void _updateState(HomeEntity newState) {
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

  // Recipe Module Functions----------------
  // Controller function to get all recipe
  Future<void> getAllRecipe({
    required BuildContext context,
    required int limit,
    bool isLoadMore = false,
  }) async {
    try {
      _updateState(_state.copyWith(isRecipeLoading: true));
      // Logic for pagination & api call based on the limit (pages).
      final skip = isLoadMore ? (_state.recipeList?.recipes?.length ?? 0) : 0;
      final newData = await _homeRepo.getRecipeRepo(limit: limit, skip: skip);

      if (isLoadMore && _state.recipeList != null) {
        final List<Recipe> currentRecipes = List.of(_state.recipeList?.recipes ?? []);
        currentRecipes.addAll(newData.recipes ?? []);

        _updateState(
          _state.copyWith(
            recipeList: _state.recipeList!.copyWith(
              recipes: currentRecipes,
            ),
            isRecipeLoading: false,
          ),
        );
      } else {
        _updateState(
          _state.copyWith(
            recipeList: newData,
            isRecipeLoading: false,
          ),
        );
      }

      log("Api Success: ${newData.recipes?.length ?? 0}");
    } catch (error) {
      if (!context.mounted) return;
      _handleError(context, error);
    } finally {
      _updateState(_state.copyWith(isRecipeLoading: false));
    }
  }

  // Controller function to get recipe details
  Future<void> getRecipeDetails({required BuildContext context, required int id}) async {
    _updateState(
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
          _updateState(
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
      _updateState(
        _state.copyWith(isRecipeDetailsLoading: false),
      );
    }
  }
}
