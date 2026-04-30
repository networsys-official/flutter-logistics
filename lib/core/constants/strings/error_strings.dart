class ErrorStrings {
  ErrorStrings._();

  // Validation Errors
  static const String requiredField = 'is required';
  static const String minNameLength = 'Name must be at least 2 characters';
  static const String invalidEmail = 'Enter a valid email address';
  static const String invalidMobile = 'Enter a valid mobile number';
  static const String minPasswordLength =
      'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';

  // Auth Errors
  static const String loginFailed = 'Login Failed: ';
  static const String registrationFailed = 'Registration Failed: ';
  static const String otpVerificationFailed = 'OTP Verification Failed: ';

  // Network Errors
  static const String connectionTimeout =
      'Connection timed out. Please check your network.';
  static const String noInternet = 'No internet connection.';
  static const String serverError = 'Server error occurred.';
  static const String unknownError = 'Unknown error occurred.';
  static const String generalError = 'An error occurred';
  static const String noInternetFriendly =
      'No internet connection. Please check your network.';
  static const String sessionExpired =
      'Your session has expired. Please login again.';
  static const String validationFailedFriendly =
      'Please check your details and try again.';
  static const String serverNotResponding =
      'Server is not responding. Please try again.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
}
