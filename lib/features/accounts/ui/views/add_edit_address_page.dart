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
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _postalCodeController;

  AddressType _selectedType = AddressType.home;
  int? _selectedLocationId;
  bool _isDefault = false;
  bool _isReceivedByMe = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.contactName);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _addressLine1Controller =
        TextEditingController(text: widget.address?.addressLine1);
    _addressLine2Controller =
        TextEditingController(text: widget.address?.addressLine2);
    _postalCodeController =
        TextEditingController(text: widget.address?.postalCode);

    if (widget.address != null) {
      _selectedType = widget.address!.type ?? AddressType.home;
      _selectedLocationId = widget.address!.locationId;
      _isDefault = widget.address!.isDefault;
      _isReceivedByMe =
          widget.address!.contactName == null && widget.address!.phone == null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final address = UserAddress(
      id: widget.address?.id ?? 0,
      type: _selectedType,
      contactName: _isReceivedByMe ? null : _nameController.text.trim(),
      phone: _isReceivedByMe ? null : _phoneController.text.trim(),
      locationId: _selectedLocationId,
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: _addressLine2Controller.text.trim().isEmpty
          ? null
          : _addressLine2Controller.text.trim(),
      postalCode: _postalCodeController.text.trim().isEmpty
          ? null
          : _postalCodeController.text.trim(),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessageFrom(error))),
          );
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
              data: (locations) => _AddressForm(
                formKey: _formKey,
                address: widget.address,
                locations: locations,
                isSubmitting: actionState.isLoading,
                selectedType: _selectedType,
                isReceivedByMe: _isReceivedByMe,
                nameController: _nameController,
                phoneController: _phoneController,
                addressLine1Controller: _addressLine1Controller,
                addressLine2Controller: _addressLine2Controller,
                postalCodeController: _postalCodeController,
                selectedLocationId: _selectedLocationId,
                isDefault: _isDefault,
                onTypeChanged: (v) => setState(() => _selectedType = v),
                onReceivedByMeChanged: (v) =>
                    setState(() => _isReceivedByMe = v),
                onLocationChanged: (v) =>
                    setState(() => _selectedLocationId = v),
                onDefaultChanged: (v) => setState(() => _isDefault = v),
                onSubmit: _submit,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(errorMessageFrom(error)),
              ),
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
  final List<Map<String, dynamic>> locations;
  final bool isSubmitting;
  final AddressType selectedType;
  final bool isReceivedByMe;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController postalCodeController;
  final int? selectedLocationId;
  final bool isDefault;
  final ValueChanged<AddressType> onTypeChanged;
  final ValueChanged<bool> onReceivedByMeChanged;
  final ValueChanged<int?> onLocationChanged;
  final ValueChanged<bool> onDefaultChanged;
  final VoidCallback onSubmit;

  const _AddressForm({
    required this.formKey,
    this.address,
    required this.locations,
    required this.isSubmitting,
    required this.selectedType,
    required this.isReceivedByMe,
    required this.nameController,
    required this.phoneController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.postalCodeController,
    required this.selectedLocationId,
    required this.isDefault,
    required this.onTypeChanged,
    required this.onReceivedByMeChanged,
    required this.onLocationChanged,
    required this.onDefaultChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
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
              onTypeChanged: onTypeChanged,
            ),
            const SizedBox(height: 24),
            const AddressSectionTitle(title: 'Contact Information'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Received by me',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral700,
                  ),
                ),
                Switch.adaptive(
                  value: isReceivedByMe,
                  activeThumbColor: AppColors.primary,
                  onChanged: onReceivedByMeChanged,
                ),
              ],
            ),
            if (!isReceivedByMe) ...[
              const SizedBox(height: 16),
              AddressFormTextField(
                controller: nameController,
                label: 'Contact Name',
                hint: 'Enter receiver name',
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AddressFormTextField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 24),
            const AddressSectionTitle(title: 'Address Details'),
            AddressLocationDropdown(
              selectedLocationId: selectedLocationId,
              locations: locations,
              onChanged: onLocationChanged,
            ),
            const SizedBox(height: 16),
            AddressFormTextField(
              controller: addressLine1Controller,
              label: 'Address Line 1',
              hint: 'Street, House No, etc.',
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            AddressFormTextField(
              controller: addressLine2Controller,
              label: 'Address Line 2 (Optional)',
              hint: 'Apartment, Suite, etc.',
            ),
            const SizedBox(height: 16),
            AddressFormTextField(
              controller: postalCodeController,
              label: 'Postal Code',
              hint: 'Enter postal code',
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
