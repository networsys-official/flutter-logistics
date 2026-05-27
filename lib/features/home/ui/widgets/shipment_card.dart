import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class ShipmentCard extends StatelessWidget {
  final String title;
  final String id;
  final String status;
  final String date;
  final bool showTimeline;
  final VoidCallback? onTap;
  final String? originCountry;
  final String? destinationCountry;
  final int activeStepIndex; // From 0 to 3

  const ShipmentCard({
    super.key,
    required this.title,
    required this.id,
    required this.status,
    required this.date,
    this.showTimeline = false,
    this.onTap,
    this.originCountry,
    this.destinationCountry,
    this.activeStepIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.neutral900,
                        ),
                      ),
                      Text(
                        '$status • $date',
                        style: const TextStyle(
                          color: AppColors.neutral500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 16,
                  color: AppColors.neutral500,
                ),
              ],
            ),
            if (showTimeline) ...[
              const SizedBox(height: 24),
              _buildTimeline(),
              const SizedBox(height: 12),
              _buildDestinations(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedPackage,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: List.generate(7, (index) {
        if (index % 2 == 0) {
          final step = index ~/ 2;
          final isCompleted = step <= activeStepIndex;
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primary : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          );
        }
        final lineIndex = index ~/ 2;
        final isCompleted = lineIndex < activeStepIndex;
        return Expanded(
          child: Container(
            height: 2,
            color: isCompleted ? AppColors.primary : AppColors.neutral200,
          ),
        );
      }),
    );
  }

  Widget _buildDestinations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          originCountry ?? 'Origin',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          destinationCountry ?? 'Destination',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
