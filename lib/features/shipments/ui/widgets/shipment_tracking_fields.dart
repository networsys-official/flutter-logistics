import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

import 'package:logistic_by_strom/core/widgets/app_searchable_select.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';

class ShipmentTrackingFields extends StatelessWidget {
  const ShipmentTrackingFields({
    super.key,
    required this.state,
    required this.trackingController,
    required this.dateController,
    required this.onTrackingChanged,
    required this.onDateTap,
    required this.onSupplierChanged,
  });

  final AddShipmentFormData state;
  final TextEditingController trackingController;
  final TextEditingController dateController;
  final ValueChanged<String> onTrackingChanged;
  final VoidCallback onDateTap;
  final ValueChanged<Supplier?> onSupplierChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Tracking Number',
          controller: trackingController,
          hint: 'Enter tracking number',
          onChanged: onTrackingChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Tracking number is required';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Expected Arrival',
          controller: dateController,
          hint: 'Select Date',
          suffixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar03,
            color: AppColors.neutral500,
            size: 20,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an arrival date';
            }
            return null;
          },
          readOnly: true,
          onTap: onDateTap,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSearchableSelect<Supplier>(
          label: 'Store/Supplier',
          hint: 'Search Store/Supplier',
          value: state.selectedSupplier,
          items: state.suppliers,
          validator: (supplier) {
            if (supplier == null) {
              return 'Please select a supplier';
            }
            return null;
          },
          itemLabelBuilder: (supplier) => supplier.company,
          onChanged: onSupplierChanged,
        ),
      ],
    );
  }
}
