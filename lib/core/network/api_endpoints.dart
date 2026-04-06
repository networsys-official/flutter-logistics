class ApiEndpoints {
  // Dummy base URL as requested
  static const String baseUrl = 'http://127.0.0.1:8080/api/v1/';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
}
