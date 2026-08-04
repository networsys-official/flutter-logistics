import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class ZoneOnboardingPage extends StatelessWidget {
  const ZoneOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: SafeArea(
        child: Column(
          children: [
            const _OnboardingHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Choose How You Receive Parcels',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _DeliveryOptionCard(
                      title: 'Pick Store (Direct Pickup)',
                      description:
                          'Visit our main pickup point at Mt. Royal Avenue, Palmdale to collect your orders directly from the warehouse.',
                      icon: Icons.storefront_outlined,
                      accentColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _DeliveryOptionCard(
                      title: 'Zone Pickup (Convenient Pickup)',
                      description:
                          'Select the delivery zone nearest to your home or office, and we will deliver the parcel to that zone for you.',
                      icon: Icons.local_shipping_outlined,
                      accentColor: AppColors.secondary,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Our Service Zones & Coverage',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Select the nearest zone when setting up your address on the next screen.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _ZoneCoverageList(),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            const _OnboardingBottomBar(),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Delivery Options & Zones',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: AppColors.neutral900,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'Step 1 of 2',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Understand how deliveries work before completing your profile.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const _DeliveryOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppSpacing.shadowSm,
        border: Border.all(
          color: AppColors.neutral200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral700,
                    height: 1.4,
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

class _ZoneCoverageList extends StatelessWidget {
  const _ZoneCoverageList();

  @override
  Widget build(BuildContext context) {
    final zones = [
      {
        'id': '1',
        'name': 'Central Core',
        'areas': 'Palmdale and nearby central addresses',
      },
      {
        'id': '2',
        'name': 'Downtown / Paradise Island',
        'areas': 'Downtown Nassau, Bay Street corridor, Paradise Island',
      },
      {
        'id': '3',
        'name': 'East Central',
        'areas': 'Prince Charles, Marathon, Village Road',
      },
      {
        'id': '4',
        'name': 'Far East',
        'areas': 'Fox Hill, Yamacraw, Eastern Road, Palm Cay',
      },
      {
        'id': '5',
        'name': 'West Corridor',
        'areas': 'Cable Beach, Sandyport, Westridge',
      },
      {
        'id': '6',
        'name': 'South / West & Gated',
        'areas': 'Carmichael, Coral Harbour, Lyford Cay, Old Fort, Adelaide',
      },
      {
        'id': '7',
        'name': 'Family Islands',
        'areas': 'Other Bahamas Islands (All islands outside New Providence)',
      },
    ];

    return Column(
      children: zones.map((zone) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _ZoneCard(
            index: zone['id']!,
            name: zone['name']!,
            areas: zone['areas']!,
          ),
        );
      }).toList(),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final String index;
  final String name;
  final String areas;

  const _ZoneCard({
    required this.index,
    required this.name,
    required this.areas,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.neutral200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.neutral900,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    index,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              areas,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => context.go(AppRoutes.setupAddress),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Continue to Address Setup',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
