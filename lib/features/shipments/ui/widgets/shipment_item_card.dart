import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/widgets/app_searchable_select.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';

class ShipmentItemCard extends StatelessWidget {
  const ShipmentItemCard({
    super.key,
    required this.index,
    required this.item,
    required this.customsDuties,
    required this.canRemove,
    required this.onRemove,
    required this.onCommodityChanged,
    required this.onPriceChanged,
    this.submissionError,
  });

  final int index;
  final ShipmentItemModel item;
  final List<CustomsDuty> customsDuties;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<CustomsDuty?> onCommodityChanged;
  final ValueChanged<double> onPriceChanged;
  final Object? submissionError;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSearchableSelect<CustomsDuty>(
            label: 'Commodity',
            hint: 'Search Commodity',
            value: item.commodity,
            items: customsDuties,
            itemLabelBuilder: (duty) => duty.item ?? 'Unknown Item',
            itemSubtitleBuilder: (duty) =>
                'Tariff: ${duty.tariffCode ?? 'N/A'}',
            onChanged: onCommodityChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Price (USD)',
            hint: '0.00',
            keyboardType: TextInputType.number,
            onChanged: (value) => onPriceChanged(double.tryParse(value) ?? 0),
            errorText: fieldErrorFrom(submissionError, 'items.$index.price'),
          ),
        ],
      ),
    );
  }
}
