import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';

class ShipmentRouteFields extends StatelessWidget {
  const ShipmentRouteFields({
    super.key,
    required this.state,
    required this.onOriginFacilityChanged,
    required this.onServiceTypeChanged,
    required this.onDeliveryTypeChanged,
    required this.onLocationChanged,

  });

  final AddShipmentFormData state;
  final ValueChanged<int> onOriginFacilityChanged;
  final ValueChanged<int> onServiceTypeChanged;
  final ValueChanged<String> onDeliveryTypeChanged;
  final ValueChanged<DeliveryZone?> onLocationChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdownField<int>(
          label: 'Origin Warehouse',
          hint: 'Select Origin',
          value: state.originFacilityId,
          validator: (value) {
            if (value == null) {
              return 'Please select an origin warehouse';
            }
            return null;
          },
          dropdownItems: const [
            DropdownMenuItem(value: 2, child: Text('Miami Warehouse (US)')),
            DropdownMenuItem(value: 3, child: Text('Shenzhen Warehouse (CN)')),
          ],
          onChanged: (value) {
            if (value != null) onOriginFacilityChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<int>(
          label: 'Service Type',
          hint: 'Select Service Type',
          value: state.serviceTypeId,
          validator: (value) {
            if (value == null) {
              return 'Please select a service type';
            }
            return null;
          },
          dropdownItems: const [
            DropdownMenuItem(value: 1, child: Text('Standard (1.25 BSD/lb)')),
            DropdownMenuItem(value: 2, child: Text('Priority (1.99 BSD/lb)')),
          ],
          onChanged: (value) {
            if (value != null) onServiceTypeChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<String>(
          label: 'Delivery Type',
          hint: 'Select Delivery Type',
          value: state.deliveryType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a delivery type';
            }
            return null;
          },
          dropdownItems: const [
            DropdownMenuItem(value: 'pickup', child: Text('Pickup from Store')),
            DropdownMenuItem(
              value: 'door_delivery',
              child: Text('Door Delivery'),
            ),
          ],
          onChanged: (value) {
            if (value != null) onDeliveryTypeChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.deliveryType == 'door_delivery') ...[
          AppDropdownField<DeliveryZone>(
            label: 'Zone',
            hint: 'Select Delivery Zone',
            value: state.selectedLocation,
            validator: (value) {
              if (value == null) {
                return 'Please select a delivery zone';
              }
              return null;
            },
            dropdownItems: state.locations
                .map(
                  (zone) => DropdownMenuItem(
                    value: zone,
                    child: Text(zone.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: onLocationChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}
