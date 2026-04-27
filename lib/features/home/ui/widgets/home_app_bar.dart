import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusMd),
          bottomRight: Radius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.neutral200,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ),
                _buildLogo(),
                _buildNotificationIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.public, color: AppColors.white, size: 16),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.logistic,
              style: TextStyle(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            Text(
              AppStrings.systems,
              style: TextStyle(
                color: AppColors.neutral700,
                fontSize: 12,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.neutral200.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_none_rounded,
        color: AppColors.neutral900,
        size: 22,
      ),
    );
  }
}
