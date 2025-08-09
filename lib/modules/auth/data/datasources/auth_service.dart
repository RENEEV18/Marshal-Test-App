import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marshal_test_app/core/config/config.dart';

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
}
