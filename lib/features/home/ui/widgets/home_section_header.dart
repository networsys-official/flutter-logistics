import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

/// A reusable section header row with a title on the left and "View All" on the right.
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.neutral900,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              AppStrings.viewAll,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
