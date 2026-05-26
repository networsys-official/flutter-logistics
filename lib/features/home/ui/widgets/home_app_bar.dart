import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.neutral100),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildLogo(), _buildNotificationIcon(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(AppImages.appBarLogo, width: 120, fit: BoxFit.contain);
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.notifications),
      borderRadius: BorderRadius.circular(24),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Badge(
          label: Text('2'),
          backgroundColor: AppColors.error,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: AppColors.neutral900,
            size: 24,
          ),
        ),
      ),
    );
  }
}
