class ApiEndpoints {
  static const String configuredBaseUrl = String.fromEnvironment(
    'http://82.29.162.169:8080/api/v1',
    defaultValue: '',
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
}
