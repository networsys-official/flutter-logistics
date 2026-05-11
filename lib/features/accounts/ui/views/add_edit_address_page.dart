import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';

class AddEditAddressPage extends ConsumerStatefulWidget {
  final UserAddress? address;

  const AddEditAddressPage({super.key, this.address});

  @override
  ConsumerState<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends ConsumerState<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _postalCodeController;
  
  AddressType _selectedType = AddressType.home;
  int? _selectedCountryId;
  int? _selectedLocationId;
  bool _isDefault = false;

  List<dynamic> _countries = [];
  List<dynamic> _locations = [];
  bool _isLoadingMetaData = false;

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
      _selectedCountryId = widget.address!.countryId;
      _selectedLocationId = widget.address!.locationId;
      _isDefault = widget.address!.isDefault;
    }

    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    setState(() => _isLoadingMetaData = true);
    try {
      final response = await ref.read(apiClientProvider).get(ApiEndpoints.countries);
      setState(() {
        _countries = response.data['data'];
        if (_selectedCountryId != null) {
          _fetchLocations(_selectedCountryId!);
        }
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoadingMetaData = false);
    }
  }

  Future<void> _fetchLocations(int countryId) async {
    try {
      final response = await ref.read(apiClientProvider).get(ApiEndpoints.locations(countryId));
      setState(() {
        _locations = response.data['data'];
      });
    } catch (e) {
      // Handle error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          AppAppBar(
            title: widget.address == null ? 'Add New Address' : 'Edit Address',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Address Type'),
                    _buildTypeSelector(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Contact Information'),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Contact Name',
                      hint: 'Enter receiver name',
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                      keyboardType: TextInputType.phone,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Address Details'),
                    _buildCountryDropdown(),
                    const SizedBox(height: 16),
                    _buildLocationDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine1Controller,
                      label: 'Address Line 1',
                      hint: 'Street, House No, etc.',
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine2Controller,
                      label: 'Address Line 2 (Optional)',
                      hint: 'Apartment, Suite, etc.',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: 'Enter postal code',
                    ),
                    const SizedBox(height: 24),
                    _buildDefaultSwitch(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral900,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: AddressType.values.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.neutral200,
                ),
              ),
              child: Center(
                child: Text(
                  type.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.white : AppColors.neutral500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Country',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedCountryId,
          items: _countries.map<DropdownMenuItem<int>>((c) {
            return DropdownMenuItem<int>(
              value: c['id'],
              child: Text(c['name']),
            );
          }).toList(),
          onChanged: (v) {
            setState(() {
              _selectedCountryId = v;
              _selectedLocationId = null;
              _locations = [];
            });
            if (v != null) _fetchLocations(v);
          },
          validator: (v) => v == null ? 'Required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedLocationId,
          items: _locations.map<DropdownMenuItem<int>>((l) {
            return DropdownMenuItem<int>(
              value: l['id'],
              child: Text(l['name']),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedLocationId = v),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultSwitch() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set as Default',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                'This address will be used by default for shipments',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: _isDefault,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => _isDefault = v),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          elevation: 0,
        ),
        child: Text(
          widget.address == null ? 'Save Address' : 'Update Address',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final address = UserAddress(
      id: widget.address?.id ?? 0,
      type: _selectedType,
      contactName: _nameController.text,
      phone: _phoneController.text,
      countryId: _selectedCountryId!,
      locationId: _selectedLocationId,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text.isEmpty ? null : _addressLine2Controller.text,
      postalCode: _postalCodeController.text.isEmpty ? null : _postalCodeController.text,
      isDefault: _isDefault,
    );

    bool success;
    if (widget.address == null) {
      success = await ref.read(userAddressViewModelProvider.notifier).addAddress(address);
    } else {
      success = await ref.read(userAddressViewModelProvider.notifier).updateAddress(address);
    }

    if (success && mounted) {
      context.pop();
    }
  }
}
