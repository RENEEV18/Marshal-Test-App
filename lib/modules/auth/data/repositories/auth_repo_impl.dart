import 'dart:convert';

import 'package:marshal_test_app/core/utils/errors/error.dart';
import 'package:marshal_test_app/core/utils/shared_pref.dart';
import 'package:marshal_test_app/modules/auth/data/datasources/auth_service.dart';
import 'package:marshal_test_app/modules/auth/data/models/login_response_model.dart';
import 'package:marshal_test_app/modules/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl extends AuthService implements AuthRepo {
  // Repo function for login
  @override
  Future<LoginResponseModel> loginRepo({required Map<String, dynamic> body}) async {
    try {
      final response = await loginService(body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final loginModel = LoginResponseModel.fromJson(data);
        await saveTokens(loginModel.accessToken ?? '', loginModel.refreshToken ?? '');
        return loginModel;
      } else {
        throw ApiErrors.handleApiError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Repo function for session storing & clearing token
  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await PrefsService.prefs.setString("accessTokenKey", accessToken);
    await PrefsService.prefs.setString("refreshTokenKey", refreshToken);
  }

  @override
  Future<Map<String, String?>> getTokens() async {
    return {
      "accessToken": PrefsService.prefs.getString("accessTokenKey"),
      "refreshToken": PrefsService.prefs.getString("refreshTokenKey"),
    };
  }

  @override
  Future<void> clearTokens() async {
    await PrefsService.prefs.remove("accessTokenKey");
    await PrefsService.prefs.remove("refreshTokenKey");
  }
}
