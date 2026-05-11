import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';

class ShipmentAddressPage extends ConsumerWidget {
  const ShipmentAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(userAddressViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(
            title: 'Shipment Address',
          ),
          Expanded(
            child: addressState.when(
              data: (addresses) => _buildAddressList(context, ref, addresses),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAddButton(context),
    );
  }

  Widget _buildAddressList(
      BuildContext context, WidgetRef ref, List<UserAddress> addresses) {
    if (addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              color: AppColors.neutral200,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'No addresses found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Add your first shipment address',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _AddressCard(address: address);
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.white,
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => context.push(AppRoutes.addAddress),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20),
              SizedBox(width: 8),
              Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  final UserAddress address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getBgColor(address.type),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: switch (address.type) {
                    AddressType.home => HugeIcons.strokeRoundedHome01,
                    AddressType.office => HugeIcons.strokeRoundedOffice,
                    AddressType.warehouse => HugeIcons.strokeRoundedWarehouse,
                    AddressType.other => HugeIcons.strokeRoundedLocation01,
                    null => HugeIcons.strokeRoundedLocation01,
                  },
                  color: _getColor(address.type),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.type?.name.toUpperCase() ?? 'ADDRESS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _getColor(address.type),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      address.contactName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
              if (address.isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              IconButton(
                onPressed: () =>
                    context.push(AppRoutes.addAddress, extra: address),
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppColors.neutral500,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showDeleteDialog(context, ref, address),
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${address.addressLine1}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.neutral500,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (address.locationName != null || address.countryName != null)
            Text(
              '${address.locationName ?? ''}${address.locationName != null && address.countryName != null ? ', ' : ''}${address.countryName ?? ''}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral500,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 16, color: AppColors.neutral200),
              const SizedBox(width: 4),
              Text(
                address.phone ?? 'No Phone',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, UserAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        title: const Text('Delete Address',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.neutral500)),
          ),
          TextButton(
            onPressed: () async {
              final success = await ref
                  .read(userAddressViewModelProvider.notifier)
                  .deleteAddress(address.id);
              if (success && context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Color _getColor(AddressType? type) {
    return switch (type) {
      AddressType.home => AppColors.primary,
      AddressType.office => AppColors.secondary,
      AddressType.warehouse => AppColors.accent,
      AddressType.other || null => AppColors.info,
    };
  }

  Color _getBgColor(AddressType? type) {
    return _getColor(type).withValues(alpha: 0.1);
  }
}
