class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  String? fieldError(String fieldName) {
    final errors = fieldErrors[fieldName];
    if (errors == null || errors.isEmpty) return null;
    return errors.first;
  }

  @override
  String toString() => message;
}
