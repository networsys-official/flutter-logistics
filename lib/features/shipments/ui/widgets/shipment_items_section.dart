import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_item_card.dart';

class ShipmentItemsSection extends StatelessWidget {
  const ShipmentItemsSection({
    super.key,
    required this.state,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onCommodityChanged,
    required this.onPriceChanged,
  });

  final AddShipmentFormData state;
  final VoidCallback onAddItem;
  final ValueChanged<int> onRemoveItem;
  final void Function(int index, CustomsDuty? value) onCommodityChanged;
  final void Function(int index, double value) onPriceChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
            ),
            TextButton.icon(
              onPressed: onAddItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...List.generate(state.items.length, (index) {
          return ShipmentItemCard(
            index: index,
            item: state.items[index],
            customsDuties: state.customsDuties,
            canRemove: state.items.length > 1,
            onRemove: () => onRemoveItem(index),
            onCommodityChanged: (value) => onCommodityChanged(index, value),
            onPriceChanged: (value) => onPriceChanged(index, value),
          );
        }),
      ],
    );
  }
}
