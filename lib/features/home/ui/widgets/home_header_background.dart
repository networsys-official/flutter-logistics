import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class HomeHeaderBackground extends StatelessWidget {
  const HomeHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // Adjusted height to cover status bar and app bar
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusSm),
          bottomRight: Radius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }
}
