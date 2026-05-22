import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/utils/ui_utils.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/shipment_list_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/add_shipment_error_banner.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_items_section.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_route_fields.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_tracking_fields.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_upload_section.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/upload_option_bottom_sheet.dart';

class AddShipmentForm extends ConsumerStatefulWidget {
  const AddShipmentForm({super.key});

  @override
  ConsumerState<AddShipmentForm> createState() => _AddShipmentFormState();
}

class _AddShipmentFormState extends ConsumerState<AddShipmentForm> {
  final _trackingController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isSubmitting = false;
  String? _localError;

  @override
  void dispose() {
    _trackingController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await UiUtils.pickDate(context);

    if (picked == null || !mounted) return;

    _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    ref.read(addShipmentViewModelProvider.notifier).updateDate(picked);
  }

  void _showUploadOptions() {
    UiUtils.showCustomBottomSheet(
      context: context,
      builder: (context) => UploadOptionBottomSheet(
        onPick: (source) {
          ref.read(addShipmentViewModelProvider.notifier).pickFile(source);
          context.pop();
        },
      ),
    );
  }

  Future<void> _openAddAddress() async {
    if (!mounted) return;
    await context.push(AppRoutes.addAddress);

    if (!mounted) return;
    await ref
        .read(addShipmentViewModelProvider.notifier)
        .refreshReferenceData();
  }

  void _showMissingAddressSnackBar({
    String message = 'Please update your address first.',
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Add Address',
            onPressed: () {
              _openAddAddress();
            },
          ),
        ),
      );
  }

  void _handleDeliveryTypeChanged(AddShipmentFormData formData, String type) {
    final notifier = ref.read(addShipmentViewModelProvider.notifier);
    notifier.updateDeliveryType(type);

    if (type != 'door_delivery' || formData.addresses.isNotEmpty) {
      return;
    }

    _showMissingAddressSnackBar();
  }

  Future<void> _submit(AddShipmentFormData formData) async {
    if (formData.addresses.isEmpty) {
      _showMissingAddressSnackBar();
      return;
    }

    if (formData.deliveryType == 'door_delivery' &&
        formData.selectedLocation != null &&
        !formData.addresses.any(
          (address) => address.zoneId == formData.selectedLocation?.id,
        )) {
      _showMissingAddressSnackBar(
        message: 'Please add an address for the selected delivery zone first.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _localError = null;
    });

    try {
      await ref.read(addShipmentViewModelProvider.notifier).submit();

      if (!mounted) return;
      ref.invalidate(shipmentListViewModelProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shipment request submitted successfully!'),
        ),
      );
      context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _localError = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(addShipmentViewModelProvider);
    final notifier = ref.read(addShipmentViewModelProvider.notifier);

    return asyncState.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'Failed to load initial data:\n$error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (formData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_localError != null)
              AddShipmentErrorBanner(message: _localError!),
            ShipmentRouteFields(
              state: formData,
              onOriginFacilityChanged: notifier.updateOriginFacility,
              onServiceTypeChanged: notifier.updateServiceType,
              onDeliveryTypeChanged: (type) =>
                  _handleDeliveryTypeChanged(formData, type),
              onLocationChanged: notifier.updateLocation,
            ),
            ShipmentTrackingFields(
              state: formData,
              trackingController: _trackingController,
              dateController: _dateController,
              onTrackingChanged: notifier.updateTrackingNumber,
              onDateTap: _selectDate,
              onSupplierChanged: notifier.updateSupplier,
            ),
            const SizedBox(height: AppSpacing.xl),
            ShipmentItemsSection(
              state: formData,
              onAddItem: notifier.addItem,
              onRemoveItem: notifier.removeItem,
              onCommodityChanged: notifier.updateItemCommodity,
              onPriceChanged: notifier.updateItemPrice,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Note for packages',
              controller: _noteController,
              hint: 'Enter your note here...',
              maxLines: 4,
              onChanged: notifier.updateNote,
            ),
            const SizedBox(height: AppSpacing.xl),
            ShipmentUploadSection(
              documents: formData.selectedDocuments,
              onUploadTap: _showUploadOptions,
              onRemoveDocument: notifier.removeDocument,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Submit Request',
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : () => _submit(formData),
            ),
          ],
        );
      },
    );
  }
}
