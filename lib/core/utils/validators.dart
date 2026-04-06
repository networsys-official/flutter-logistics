class Validators {
  Validators._();

  /// Validates that a field is not empty.
  /// Returns an error message if the value is null or empty.
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a person's name.
  /// Checks for requirement and minimum length of 2 characters.
  static String? name(String? value) {
    final requiredError = required(value, 'Name');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validates an email address using a standard regular expression.
  static String? email(String? value) {
    final requiredError = required(value, 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validates a mobile number.
  /// Ensures it's not empty and follows a basic digit-only pattern (can be adjusted for specific regions).
  static String? mobile(String? value) {
    final requiredError = required(value, 'Mobile number');
    if (requiredError != null) {
      return requiredError;
    }

    final mobileRegex = RegExp(r'^[0-9+]{8,15}$');
    if (!mobileRegex.hasMatch(value!.trim())) {
      return 'Enter a valid mobile number';
    }

    return null;
  }

  /// Validates password strength.
  /// Currently checks for a minimum length of 6 characters.
  static String? password(String? value) {
    final requiredError = required(value, 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates that the confirm password matches the original password.
  static String? confirmPassword(String? value, String password) {
    final requiredError = required(value, 'Confirm password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
