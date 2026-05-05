import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Support'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1549923746-c502d488b3ea?q=80&w=1000&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'CONNECT WITH US',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Contact Cards
            const Padding(
              padding: AppSpacing.paddingHorizontalMd,
              child: Column(
                children: [
                  _ContactCard(
                    icon: HugeIcons.strokeRoundedCall02,
                    label: 'Phone No.',
                    value: '+236 1234567890',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ContactCard(
                    icon: HugeIcons.strokeRoundedMail01,
                    label: 'Email Address',
                    value: 'example@gmail.com',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ContactCard(
                    icon: HugeIcons.strokeRoundedLocation01,
                    label: 'Head Office',
                    value: 'Noida One sec 63',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String value;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              icon: icon,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.neutral500,
                        fontWeight: FontWeight.w500,
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
