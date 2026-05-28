import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/notifications/ui/view_models/notifications_view_model.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.neutral100),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildLogo(), _buildNotificationIcon(context, ref)],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(AppImages.appBarLogo, width: 120, fit: BoxFit.contain);
  }

  Widget _buildNotificationIcon(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsViewModelProvider);
    
    final unreadCount = notificationsAsync.maybeWhen(
      data: (list) => list.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    final icon = const HugeIcon(
      icon: HugeIcons.strokeRoundedNotification01,
      color: AppColors.neutral900,
      size: 24,
    );

    return InkWell(
      onTap: () => context.push(AppRoutes.notifications),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: unreadCount > 0
            ? Badge(
                label: Text(unreadCount.toString()),
                backgroundColor: AppColors.error,
                child: icon,
              )
            : icon,
      ),
    );
  }
}
