import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marshal_test_app/core/config/config.dart';

abstract class HomeServices {
  final apiHeaders = {"Content-Type": "application/json"};

  // Service function for get all recipe with pagination
  Future<http.Response> getRecipeService({required int limit, required int skip}) async {
    try {
      final uri = Uri.parse(AppConfig.apiRecipeBaseUrl).replace(
        queryParameters: {
          "limit": limit.toString(),
          "skip": skip.toString(),
        },
      );
      final response = await http.get(
        uri,
        headers: apiHeaders,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Service function for get recipe details
  Future<http.Response> getRecipeDetailsService({required int id}) async {
    try {
      final uri = Uri.parse("${AppConfig.apiRecipeBaseUrl}/$id");
      final response = await http.get(
        uri,
        headers: apiHeaders,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Service function to search recipe
  Future<http.Response> searchRecipeService({required int limit, required String query, required int skip}) async {
    try {
      final uri = Uri.parse(AppConfig.apiRecipeBaseUrl + AppEndpoints.searchRecipe).replace(
        queryParameters: {
          "q": query.toString(),
          "limit": limit.toString(),
          "skip": skip.toString(),
        },
      );
      final response = await http.get(
        uri,
        headers: apiHeaders,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Service function to update recipe (PUT)
  Future<http.Response> updateRecipeService({
    required int id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = Uri.parse("${AppConfig.apiRecipeBaseUrl}/$id");
      final response = await http.put(
        uri,
        headers: apiHeaders,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
