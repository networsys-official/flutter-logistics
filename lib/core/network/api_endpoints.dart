class ApiEndpoints {
  static const String configuredBaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://82.29.162.169:8080/api/v1',
  );

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/send-otp';
  static const String forgetPassword = '/auth/forgot-password';
  static const String restPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User/Account endpoints
  static const String updateProfile = '/profile';
  static const String showProfile = '/profile';

  // Calculator endpoints
  static const String calculate = '/calculator/calculate';
}
