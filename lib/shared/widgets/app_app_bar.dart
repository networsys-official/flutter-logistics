import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class AppAppBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.neutral100,
      ),
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
              if (showNotification) _buildNotificationIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return InkWell(
      onTap: () {},
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
