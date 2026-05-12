import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';

class AddressCard extends ConsumerWidget {
  final UserAddress address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Safely map string label back to enum for UI color/icon
    final typeEnum = AddressType.values.firstWhere(
      (e) => e.name == address.label,
      orElse: () => AddressType.home,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.neutral200.withValues(alpha: 0.5),
          width: address.isDefault ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AddressCardIcon(type: typeEnum),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label?.toUpperCase() ?? 'ADDRESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _getColor(typeEnum),
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          const _AddressDefaultBadge(),
                        ],
                      ],
                    ),
                    Text(
                      address.poBox ?? 'No P.O. Box',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
              _AddressCardActionButtons(
                address: address,
                onDelete: () => _showDeleteDialog(context, ref, address),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AddressCardDetails(address: address),
          const SizedBox(height: 12),
          _AddressCardLocationInfo(address: address),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    UserAddress address,
  ) {
    showDialog(
      context: context,
      builder: (context) => _DeleteAddressDialog(
        onConfirm: () async {
          final success = await ref
              .read(userAddressViewModelProvider.notifier)
              .deleteAddress(address.id);
          if (success && context.mounted) {
            Navigator.pop(context);
          }
        },
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
}

class _AddressCardIcon extends StatelessWidget {
  final AddressType? type;
  const _AddressCardIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      AddressType.home => AppColors.primary,
      AddressType.office => AppColors.secondary,
      AddressType.warehouse => AppColors.accent,
      AddressType.other || null => AppColors.info,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: HugeIcon(
        icon: switch (type) {
          AddressType.home => HugeIcons.strokeRoundedHome01,
          AddressType.office => HugeIcons.strokeRoundedOffice,
          AddressType.warehouse => HugeIcons.strokeRoundedWarehouse,
          AddressType.other => HugeIcons.strokeRoundedLocation01,
          null => HugeIcons.strokeRoundedLocation01,
        },
        color: color,
        size: 18,
      ),
    );
  }
}

class _AddressDefaultBadge extends StatelessWidget {
  const _AddressDefaultBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'DEFAULT',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _AddressCardActionButtons extends StatelessWidget {
  final UserAddress address;
  final VoidCallback onDelete;

  const _AddressCardActionButtons({
    required this.address,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: Icons.edit_outlined,
          color: AppColors.neutral500,
          onTap: () => context.push(AppRoutes.addAddress, extra: address),
        ),
        const SizedBox(width: 8),
        _ActionButton(
          icon: Icons.delete_outline,
          color: AppColors.error.withValues(alpha: 0.8),
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _AddressCardDetails extends StatelessWidget {
  final UserAddress address;
  const _AddressCardDetails({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${address.addressLine1}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.neutral700,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (address.zone != null || address.city != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '${address.zone ?? ''}${address.zone != null && address.city != null ? ', ' : ''}${address.city ?? ''}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.neutral500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _AddressCardLocationInfo extends StatelessWidget {
  final UserAddress address;
  const _AddressCardLocationInfo({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedLocation01,
          size: 14,
          color: AppColors.neutral500,
        ),
        const SizedBox(width: 6),
        Text(
          address.island ?? 'No Island',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.neutral700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeleteAddressDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _DeleteAddressDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Delete Address',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: const Text(
        'Are you sure you want to delete this address? This action cannot be undone.',
        style: TextStyle(color: AppColors.neutral700, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.neutral500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text(
            'Delete',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
