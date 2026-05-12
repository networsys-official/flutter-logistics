import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class EmptyAddressesView extends StatelessWidget {
  const EmptyAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedLocation01,
            color: AppColors.neutral200,
            size: 64,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Add your first shipment address',
            style: TextStyle(fontSize: 14, color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }
}
