/// Utility functions for Map operations.
class MapUtils {
  MapUtils._();

  /// Safely converts a dynamic value to a `Map<String, dynamic>`.
  /// If the value is already a `Map<String, dynamic>`, it returns it directly.
  /// If it is a generic Map, it converts all keys to Strings.
  /// Otherwise, it returns an empty Map.
  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return const <String, dynamic>{};
  }
}
