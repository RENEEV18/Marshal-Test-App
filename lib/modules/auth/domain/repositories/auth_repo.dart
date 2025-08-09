import 'package:marshal_test_app/modules/auth/data/models/login_response_model.dart';

abstract class AuthRepo {
  // Repo function for login
  Future<LoginResponseModel> loginRepo({required Map<String, dynamic> body});
  // Function to store & get token (sessions)
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<Map<String, String?>> getTokens();
  Future<void> clearTokens();
}
