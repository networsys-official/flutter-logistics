import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_action_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_locations_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/address_form_widgets.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';

class SetupAddressPage extends ConsumerStatefulWidget {
  const SetupAddressPage({super.key});

  @override
  ConsumerState<SetupAddressPage> createState() => _SetupAddressPageState();
}

class _SetupAddressPageState extends ConsumerState<SetupAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _islandController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _poBoxController;

  String _label = 'home';
  int? _selectedZoneId;
  bool _isDefault = true; // Default address for new user should be true

  @override
  void initState() {
    super.initState();
    _islandController = TextEditingController(text: 'New Providence');
    _addressLine1Controller = TextEditingController();
    _poBoxController = TextEditingController();
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
      id: 0,
      label: _label,
      zoneId: _selectedZoneId,
      island: _islandController.text.trim().isEmpty
          ? 'New Providence'
          : _islandController.text.trim(),
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: null,
      poBox: _poBoxController.text.trim().isEmpty
          ? null
          : _poBoxController.text.trim(),
      isDefault: _isDefault,
    );

    final bool success = await ref
        .read(userAddressActionProvider.notifier)
        .addAddress(address);

    if (success && mounted) {
      // Upon success, the go_router redirection will also trigger because the address list has updated
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(userAddressLocationsProvider);
    final actionState = ref.watch(userAddressActionProvider);
    final textTheme = Theme.of(context).textTheme;

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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.neutral200,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Setup Address',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.neutral900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          'Step 2 of 2',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Set your primary delivery location to continue to home.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: locationsAsync.when(
                data: (zones) => SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AddressSectionTitle(title: 'Address Type'),
                        AddressTypeSelector(
                          selectedType: AddressType.values.firstWhere(
                            (e) => e.name == _label,
                            orElse: () => AddressType.home,
                          ),
                          onTypeChanged: (v) => setState(() => _label = v.name),
                        ),
                        const SizedBox(height: 24),
                        AddressFormTextField(
                          controller: _islandController,
                          label: 'Island',
                          hint: 'Enter Island',
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 24),
                        const AddressSectionTitle(title: 'Address Details'),
                        AddressFormTextField(
                          controller: _addressLine1Controller,
                          label: 'Street Address',
                          hint: 'Street, House No, etc.',
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        AddressFormTextField(
                          controller: _poBoxController,
                          label: 'P.O. Box (Optional)',
                          hint: 'Enter P.O. Box',
                        ),
                        const SizedBox(height: 16),
                        AddressZoneDropdown(
                          selectedZoneId: _selectedZoneId,
                          zones: zones,
                          onChanged: (v) => setState(() => _selectedZoneId = v),
                        ),
                        const SizedBox(height: 24),
                        AddressDefaultSwitch(
                          isDefault: _isDefault,
                          onChanged: (v) => setState(() => _isDefault = v),
                        ),
                        const SizedBox(height: 40),
                        AddressSubmitButton(
                          isSubmitting: actionState.isLoading,
                          onPressed: _submit,
                          label: 'Save & Continue to Home',
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text(errorMessageFrom(error))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
