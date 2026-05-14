import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/calculator/ui/view_models/calculator_view_model.dart';

class DimensionInputs extends ConsumerWidget {
  const DimensionInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calculatorViewModelProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Length',
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => notifier.updateLength(double.tryParse(val) ?? 0),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Width',
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => notifier.updateWidth(double.tryParse(val) ?? 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Height',
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => notifier.updateHeight(double.tryParse(val) ?? 0),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Weight (lbs)',
                hint: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => notifier.updateWeight(double.tryParse(val) ?? 0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
