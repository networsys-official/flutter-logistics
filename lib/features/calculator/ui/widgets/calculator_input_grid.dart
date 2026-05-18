import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/providers/reference_data_provider.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/core/widgets/app_searchable_select.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/calculator/ui/view_models/calculator_view_model.dart';
import 'package:logistic_by_strom/features/calculator/ui/widgets/delivery_type_toggle.dart';
import 'package:logistic_by_strom/features/calculator/ui/widgets/dimension_inputs.dart';
import 'package:logistic_by_strom/features/calculator/ui/widgets/shipping_method_toggle.dart';

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

        const DimensionInputs(),

        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Price (\$)',
          hint: '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) => notifier.updatePrice(double.tryParse(val) ?? 0),
        ),
        const SizedBox(height: AppSpacing.md),

        // Dynamic Item Type (Customs Duties) Dropdown using Pattern Matching
        switch (referenceData) {
          AsyncData(:final value) => AppSearchableSelect<CustomsDuty>(
            label: 'Item Type',
            hint: 'Search Item Type',
            value: state.tariffCode != null
                ? value.customsDuties
                      .where((d) => d.id == state.tariffCode)
                      .firstOrNull
                : null,
            items: value.customsDuties,
            itemLabelBuilder: (duty) => duty.item ?? 'Unknown',
            itemSubtitleBuilder: (duty) =>
                'Tariff Code: ${duty.tariffCode ?? 'N/A'}',
            onChanged: (val) => notifier.updateTariffCode(val?.id),
          ),
          AsyncError(:final error) => Text('Failed to load item types: $error'),
          _ => const Center(child: CircularProgressIndicator()),
        },

        const SizedBox(height: AppSpacing.lg),

        const DeliveryTypeToggle(),

        if (state.deliveryType == 'door_delivery') ...[
          const SizedBox(height: AppSpacing.md),
          switch (referenceData) {
            AsyncData(:final value) => AppDropdownField<int>(
              label: 'Zone',
              hint: 'Select Zone',
              value: state.destinationLocationId,
              dropdownItems: value.locations
                  .map(
                    (zone) => DropdownMenuItem(
                      value: zone.id,
                      child: Text(zone.name),
                    ),
                  )
                  .toList(),
              onChanged: (val) => notifier.updateDestinationLocation(val),
            ),
            AsyncError(:final error) => Text('Failed to load zones: $error'),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ],

        const SizedBox(height: AppSpacing.lg),

        const ShippingMethodToggle(),

        const SizedBox(height: AppSpacing.xl),

        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
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
