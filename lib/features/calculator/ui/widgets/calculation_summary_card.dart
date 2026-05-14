import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/calculator/ui/view_models/calculator_view_model.dart';

class CalculationSummaryCard extends ConsumerWidget {
  const CalculationSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorViewModelProvider);
    final estimate = state.estimate;

    if (estimate == null) {
      return const SizedBox.shrink();
    }

    final breakdown = estimate.breakdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calculation Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.neutral900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: AppSpacing.shadowSm,
          ),
          child: Column(
            children: [
              _SummaryRow(label: 'Shipping Price', value: '\$${breakdown.shippingPrice.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.md),
              if (breakdown.deliverySurcharge > 0) ...[
                _SummaryRow(label: 'Delivery Surcharge', value: '\$${breakdown.deliverySurcharge.toStringAsFixed(2)}'),
                const SizedBox(height: AppSpacing.md),
              ],
              _SummaryRow(label: 'Customs Duty', value: '\$${breakdown.customsDuty.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'Processing Fee', value: '\$${breakdown.processingFee.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'Document Fee', value: '\$${breakdown.documentFee.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'VAT', value: '\$${breakdown.vat.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.lg),
              _buildDashedLine(),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral900,
                    ),
                  ),
                  Text(
                    '\$${estimate.estimatedPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppColors.neutral200),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
      ],
    );
  }
}
