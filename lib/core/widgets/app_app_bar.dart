import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/notifications/ui/view_models/notifications_view_model.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showNotification;
  final List<Widget>? actions;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showNotification = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.neutral100),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  color: AppColors.neutral900,
                ),
                const SizedBox(width: 8),
              ] else ...[
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (actions != null) ...actions!,
              if (showNotification) _buildNotificationIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notificationsAsync = ref.watch(notificationsViewModelProvider);
        final theme = Theme.of(context);

        final unreadCount = notificationsAsync.maybeWhen(
          data: (list) => list.where((n) => !n.isRead).length,
          orElse: () => 0,
        );

        final icon = HugeIcon(
          icon: HugeIcons.strokeRoundedNotification01,
          color: theme.colorScheme.onSurface,
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
      },
    );
  }
}
