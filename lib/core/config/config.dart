class AppConfig {
  // Base URL Constants
  static const apiAuthBaseUrl = "https://dummyjson.com/auth/";
  static const apiRecipeBaseUrl = "https://dummyjson.com/recipes";
}

class AppEndpoints {
  // Auth Endpoints
  static const login = 'login';
  static const getUser = 'me';
  static const refreshToken = 'refresh';
  // Recipe Endpoints
  static const searchRecipe = '/search';
}
