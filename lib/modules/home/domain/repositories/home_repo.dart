import 'package:marshal_test_app/modules/home/data/models/get_recipe_details.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_model.dart';

abstract class HomeRepo {
  // Repo function for get all recipe
  Future<GetRecipeModel> getRecipeRepo({required int limit, required int skip});
  // Repo function for get recipe details (single-one)
  Future<GetRecipeDetailsModel> getRecipeDetailsRepo({required int recipeId});
  // Repo function to search recipe
  Future<GetRecipeModel> searchRecipeRepo({required int limit, required String query, required int skip});
  // Repo function to update the recipe
  Future<GetRecipeDetailsModel> updateRecipeRepo({
    required int recipeId,
    required Map<String, dynamic> body,
  });
}
