import 'dart:convert';

import 'package:marshal_test_app/core/utils/errors/error.dart';
import 'package:marshal_test_app/modules/home/data/datasources/home_services.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_details.dart';
import 'package:marshal_test_app/modules/home/data/models/get_recipe_model.dart';
import 'package:marshal_test_app/modules/home/domain/repositories/home_repo.dart';

class HomeRepoImpl extends HomeServices implements HomeRepo {
  // Repo function to get all recipes
  @override
  Future<GetRecipeModel> getRecipeRepo({required int limit, required int skip}) async {
    try {
      final response = await getRecipeService(limit: limit, skip: skip);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return GetRecipeModel.fromJson(data);
      } else {
        throw ApiErrors.handleApiError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Repo function to get recipe details
  @override
  Future<GetRecipeDetailsModel> getRecipeDetailsRepo({required int recipeId}) async {
    try {
      final response = await getRecipeDetailsService(id: recipeId);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return GetRecipeDetailsModel.fromJson(data);
      } else {
        throw ApiErrors.handleApiError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Repo function to search recipe
  @override
  Future<GetRecipeModel> searchRecipeRepo({required int limit, required String query, required int skip}) async {
    try {
      final response = await searchRecipeService(limit: limit, query: query, skip: skip);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return GetRecipeModel.fromJson(data);
      } else {
        throw ApiErrors.handleApiError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Repo function to update recipe
  @override
  Future<GetRecipeDetailsModel> updateRecipeRepo({
    required int recipeId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await updateRecipeService(id: recipeId, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return GetRecipeDetailsModel.fromJson(data);
      } else {
        throw ApiErrors.handleApiError(response);
      }
    } catch (e) {
      rethrow;
    }
  }
}
