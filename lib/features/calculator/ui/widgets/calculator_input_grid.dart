import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/providers/reference_data_provider.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/calculator/ui/view_models/calculator_view_model.dart';

class CalculatorInputGrid extends ConsumerWidget {
  const CalculatorInputGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorViewModelProvider);
    final referenceData = ref.watch(referenceDataProvider);
    final notifier = ref.read(calculatorViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Dimensions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.neutral900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Price (\$)',
          hint: '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) => notifier.updatePrice(double.tryParse(val) ?? 0),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Dynamic Item Type (Customs Duties) Dropdown
        referenceData.when(
          data: (data) => AppDropdownField<int>(
            label: 'Item Type',
            hint: 'Select Item Type',
            value: state.tariffCode,
            dropdownItems: data.customsDuties
                .map((duty) => DropdownMenuItem(
                      value: duty.id,
                      child: Text(duty.item ?? 'Unknown'),
                    ))
                .toList(),
            onChanged: (val) => notifier.updateTariffCode(val),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Failed to load item types'),
        ),

        const SizedBox(height: AppSpacing.lg),
        
        // Delivery Type Toggle
        const _DeliveryTypeOptions(),

        if (state.deliveryType == 'door_delivery') ...[
          const SizedBox(height: AppSpacing.md),
          referenceData.when(
            data: (data) => AppDropdownField<int>(
              label: 'Zone',
              hint: 'Select Zone',
              value: state.destinationLocationId,
              dropdownItems: data.locations
                  .map((zone) => DropdownMenuItem(
                        value: zone.id,
                        child: Text(zone.name),
                      ))
                  .toList(),
              onChanged: (val) => notifier.updateDestinationLocation(val),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Failed to load zones'),
          ),
        ],

        const SizedBox(height: AppSpacing.lg),
        const _ShippingOptions(),

        const SizedBox(height: AppSpacing.xl),
        
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),

        AppButton(
          text: 'Calculate',
          isLoading: state.isLoading,
          onPressed: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard
            notifier.calculate();
          },
        ),
      ],
    );
  }
}

class _DeliveryTypeOptions extends ConsumerWidget {
  const _DeliveryTypeOptions();

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
            'Delivery Type',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral500,
            ),
          ),
        ),
        Row(
          children: [
            _buildOption('Store Pickup', 'pickup', state.deliveryType, (v) => notifier.updateDeliveryType(v)),
            const SizedBox(width: 24),
            _buildOption('Door Delivery', 'door_delivery', state.deliveryType, (v) => notifier.updateDeliveryType(v)),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(String label, String value, String currentValue, Function(String) onChanged) {
    final isSelected = currentValue == value;
    return InkWell(
      onTap: () => onChanged(value),
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

class _ShippingOptions extends ConsumerWidget {
  const _ShippingOptions();

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
            _buildOption('Standard', 'standard', state.shippingType, (v) => notifier.updateShippingType(v)),
            const SizedBox(width: 24),
            _buildOption('Priority', 'priority', state.shippingType, (v) => notifier.updateShippingType(v)),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(String label, String value, String currentValue, Function(String) onChanged) {
    final isSelected = currentValue == value;
    return InkWell(
      onTap: () => onChanged(value),
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
