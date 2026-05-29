import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          AppAppBar(title: 'About App'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppSpacing.xl),
                  _AboutHeader(),
                  SizedBox(height: AppSpacing.xl),
                  _AboutDescriptionCard(),
                  SizedBox(height: AppSpacing.xl),
                  _AboutActions(),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: AppSpacing.shadowMd,
          ),
          child: Image.asset(
            AppImages.logo,
            height: 72,
            width: 72,
            errorBuilder: (context, error, stackTrace) {
              return const HugeIcon(
                icon: HugeIcons.strokeRoundedDeliveryTruck01,
                color: AppColors.primary,
                size: 72,
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Logistic by Strom',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.neutral900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Version 1.0.0 (100)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral500,
          ),
        ),
      ],
    );
  }
}

class _AboutDescriptionCard extends StatelessWidget {
  const _AboutDescriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: const Text(
        'Logistic by Strom is designed to make shipping easy, fast, and reliable for the people and businesses of The Bahamas. Our mission is to simplify logistics by providing seamless booking, real-time shipment updates, and transparent calculators tailored specifically to local and international cargo needs.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.neutral700,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}



class _AboutActions extends StatelessWidget {
  const _AboutActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: TextButton(
        onPressed: () {
          showLicensePage(
            context: context,
            applicationName: 'Logistic by Strom',
            applicationVersion: '1.0.0',
            applicationIcon: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                AppImages.logo,
                height: 48,
                width: 48,
                errorBuilder: (context, error, stackTrace) {
                  return const HugeIcon(
                    icon: HugeIcons.strokeRoundedDeliveryTruck01,
                    color: AppColors.primary,
                    size: 48,
                  );
                },
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
        ),
        child: const Text(
          'View Open Source Licenses',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
