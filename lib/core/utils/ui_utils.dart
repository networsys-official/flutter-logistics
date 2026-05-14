import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class UiUtils {
  UiUtils._();

  /// Shows a date picker with the app's primary color theme.
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
  }

  /// Shows a generic bottom sheet.
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    Color backgroundColor = Colors.transparent,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }
}
