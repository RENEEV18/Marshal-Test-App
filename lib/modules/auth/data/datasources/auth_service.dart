import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marshal_test_app/core/config/config.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';

abstract class AuthService {
  final apiHeaders = {"Content-Type": "application/json"};

  // Service function for auth login
  Future<http.Response> loginService({
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = Uri.parse(AppConfig.apiAuthBaseUrl + AppEndpoints.login);
      final response = await http.post(
        uri,
        headers: apiHeaders,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Service function for getting user profile
  Future<http.Response> getUserService() async {
    try {
      final uri = Uri.parse(AppConfig.apiAuthBaseUrl + AppEndpoints.getUser);
      final response = await http.get(
        uri,
        headers: {
          ...apiHeaders,
          "Authorization": "Bearer ${PrefsService.prefs.getString("accessTokenKey")}",
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Service function to refresh the seesion
  Future<http.Response> refreshTokenService() async {
    try {
      final uri = Uri.parse(AppConfig.apiAuthBaseUrl + AppEndpoints.refreshToken);
      final response = await http.post(
        uri,
        headers: apiHeaders,
        body: jsonEncode(
          {
            "refreshToken": PrefsService.prefs.getString("refreshTokenKey"),
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
