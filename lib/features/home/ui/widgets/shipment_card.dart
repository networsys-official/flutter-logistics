import 'package:flutter/material.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';

class ShipmentCard extends StatelessWidget {
  final String title;
  final String id;
  final String status;
  final String date;
  final bool showTimeline;

  const ShipmentCard({
    super.key,
    required this.title,
    required this.id,
    required this.status,
    required this.date,
    this.showTimeline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      style: const TextStyle(color: AppColors.neutral500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
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
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: List.generate(7, (index) {
        if (index % 2 == 0) {
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: index < 5 ? AppColors.primary : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          );
        }
        return Expanded(
          child: Container(
            height: 2,
            color: index < 5 ? AppColors.primary : AppColors.neutral200,
          ),
        );
      }),
    );
  }

  Widget _buildDestinations() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'USA',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          'Bahamas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
