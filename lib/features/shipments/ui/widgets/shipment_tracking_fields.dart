import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/shipments/data/models/supplier.dart';
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
          readOnly: true,
          onTap: onDateTap,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<Supplier>(
          label: 'Store/Supplier',
          hint: 'Select Store/Supplier',
          value: state.selectedSupplier,
          dropdownItems: state.suppliers
              .map(
                (supplier) => DropdownMenuItem(
                  value: supplier,
                  child: Text(
                    supplier.company,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onSupplierChanged,
        ),
      ],
    );
  }
}
