import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/shared/widgets/app_app_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(
            title: 'Support',
            showBackButton: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  // Banner Image
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      child: Image.asset(
                        AppImages.container,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Title Section
                  Text(
                    'How can we help you?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.neutral900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our team is available to assist you with any questions or concerns.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutral700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Contact Cards
                  const _ContactCard(
                    icon: HugeIcons.strokeRoundedCall02,
                    label: 'Phone No.',
                    value: '+236 1234567890',
                    iconColor: AppColors.secondary,
                    iconBgColor: Color(0xFFD6EEF4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _ContactCard(
                    icon: HugeIcons.strokeRoundedMail01,
                    label: 'Email Address',
                    value: 'support@strom.com',
                    iconColor: AppColors.primary,
                    iconBgColor: Color(0xFFE8F5E9),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _ContactCard(
                    icon: HugeIcons.strokeRoundedLocation01,
                    label: 'Head Office',
                    value: 'Noida One, Sector 63, UP',
                    iconColor: AppColors.accent,
                    iconBgColor: Color(0xFFFFF0D9),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBgColor;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              icon: icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.neutral900,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
