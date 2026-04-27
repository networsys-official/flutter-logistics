import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class HomeFab extends StatelessWidget {
  const HomeFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primary,
      elevation: 8,
      shape: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: const Icon(
          Icons.add_box_outlined,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}
