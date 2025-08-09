import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marshal_test_app/core/utils/snackbar.dart';

class ApiErrors {
  // Function for error handling based on the status code.
  static Exception handleApiError(http.Response response) {
    String message;
    SnackbarType type = SnackbarType.error;

    switch (response.statusCode) {
      case 400:
        message = "Bad request. Please check your input.";
        break;
      case 401:
        message = "Unauthorized. Please check your credentials.";
        break;
      case 403:
        message = "Forbidden request.";
        break;
      case 404:
        message = "Data not found.";
        break;
      case 500:
        message = "Server error. Please try again later.";
        break;
      default:
        message = "Unexpected error: ${response.statusCode}";
    }

    try {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody is Map && jsonBody['message'] != null) {
        message = jsonBody['message'];
      }
    } catch (_) {}
    return ApiException(message, type);
  }
}

class ApiException implements Exception {
  final String message;
  final SnackbarType type;
  ApiException(this.message, this.type);
}
