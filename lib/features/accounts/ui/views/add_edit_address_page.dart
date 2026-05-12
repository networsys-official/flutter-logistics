import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_action_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_locations_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/address_form_widgets.dart';

class AddEditAddressPage extends ConsumerStatefulWidget {
  final UserAddress? address;

  const AddEditAddressPage({super.key, this.address});

  @override
  ConsumerState<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends ConsumerState<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _islandController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _poBoxController;

  String _label = 'home';
  int? _selectedZoneId;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _islandController = TextEditingController(
      text: widget.address?.island ?? 'New Providence',
    );
    _addressLine1Controller = TextEditingController(
      text: widget.address?.addressLine1,
    );
    _poBoxController = TextEditingController(text: widget.address?.poBox);

    if (widget.address != null) {
      _label = widget.address!.label ?? 'home';
      _selectedZoneId = widget.address!.zoneId;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _islandController.dispose();
    _addressLine1Controller.dispose();
    _poBoxController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final address = UserAddress(
      id: widget.address?.id ?? 0,
      label: _label,
      zoneId: _selectedZoneId,
      island: _islandController.text.trim().isEmpty
          ? 'New Providence'
          : _islandController.text.trim(),
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: null, // Address Line 2 removed from UI
      poBox: _poBoxController.text.trim().isEmpty
          ? null
          : _poBoxController.text.trim(),
      isDefault: _isDefault,
    );

    final bool success;
    if (widget.address == null) {
      success = await ref
          .read(userAddressActionProvider.notifier)
          .addAddress(address);
    } else {
      success = await ref
          .read(userAddressActionProvider.notifier)
          .updateAddress(address);
    }

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(userAddressLocationsProvider);
    final actionState = ref.watch(userAddressActionProvider);

    ref.listen(userAddressActionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessageFrom(error))));
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          AppAppBar(
            title: widget.address == null ? 'Add New Address' : 'Edit Address',
          ),
          Expanded(
            child: locationsAsync.when(
              data: (zones) => _AddressForm(
                formKey: _formKey,
                address: widget.address,
                zones: zones,
                isSubmitting: actionState.isLoading,
                label: _label,
                islandController: _islandController,
                addressLine1Controller: _addressLine1Controller,
                poBoxController: _poBoxController,
                selectedZoneId: _selectedZoneId,
                isDefault: _isDefault,
                onLabelChanged: (v) => setState(() => _label = v.name),
                onZoneChanged: (v) => setState(() => _selectedZoneId = v),
                onDefaultChanged: (v) => setState(() => _isDefault = v),
                onSubmit: _submit,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text(errorMessageFrom(error))),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UserAddress? address;
  final List<Map<String, dynamic>> zones;
  final bool isSubmitting;
  final String label;
  final TextEditingController islandController;
  final TextEditingController addressLine1Controller;
  final TextEditingController poBoxController;
  final int? selectedZoneId;
  final bool isDefault;
  final ValueChanged<AddressType> onLabelChanged;
  final ValueChanged<int?> onZoneChanged;
  final ValueChanged<bool> onDefaultChanged;
  final VoidCallback onSubmit;

  const _AddressForm({
    required this.formKey,
    this.address,
    required this.zones,
    required this.isSubmitting,
    required this.label,
    required this.islandController,
    required this.addressLine1Controller,
    required this.poBoxController,
    required this.selectedZoneId,
    required this.isDefault,
    required this.onLabelChanged,
    required this.onZoneChanged,
    required this.onDefaultChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    // Safely map string label back to enum for UI selector
    final selectedType = AddressType.values.firstWhere(
      (e) => e.name == label,
      orElse: () => AddressType.home,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddressSectionTitle(title: 'Address Type'),
            AddressTypeSelector(
              selectedType: selectedType,
              onTypeChanged: onLabelChanged,
            ),
            const SizedBox(height: 24),
            AddressFormTextField(
              controller: islandController,
              label: 'Island',
              hint: 'Enter Island',
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            const AddressSectionTitle(title: 'Address Details'),
            AddressFormTextField(
              controller: addressLine1Controller,
              label: 'Street Address',
              hint: 'Street, House No, etc.',
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            AddressFormTextField(
              controller: poBoxController,
              label: 'P.O. Box (Optional)',
              hint: 'Enter P.O. Box',
            ),
            const SizedBox(height: 16),
            AddressZoneDropdown(
              selectedZoneId: selectedZoneId,
              zones: zones,
              onChanged: onZoneChanged,
            ),
            const SizedBox(height: 24),
            AddressDefaultSwitch(
              isDefault: isDefault,
              onChanged: onDefaultChanged,
            ),
            const SizedBox(height: 40),
            AddressSubmitButton(
              isSubmitting: isSubmitting,
              onPressed: onSubmit,
              label: address == null ? 'Save Address' : 'Update Address',
            ),
          ],
        ),
      ),
    );
  }
}
