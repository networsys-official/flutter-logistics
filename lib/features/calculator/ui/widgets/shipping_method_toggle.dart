import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/calculator/ui/view_models/calculator_view_model.dart';

class ShippingMethodToggle extends ConsumerWidget {
  const ShippingMethodToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorViewModelProvider);
    final notifier = ref.read(calculatorViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Shipping Method',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral500,
            ),
          ),
        ),
        Row(
          children: [
            _OptionItem(
              label: 'Standard',
              value: 'standard',
              isSelected: state.shippingType == 'standard',
              onTap: () => notifier.updateShippingType('standard'),
            ),
            const SizedBox(width: 24),
            _OptionItem(
              label: 'Priority',
              value: 'priority',
              isSelected: state.shippingType == 'priority',
              onTap: () => notifier.updateShippingType('priority'),
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionItem({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.neutral200,
                width: 2,
              ),
            ),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.neutral900 : AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
