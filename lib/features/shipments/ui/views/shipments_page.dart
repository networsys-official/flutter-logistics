// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_accordion.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/shipment_list_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/shipment_accordion_tile.dart';

class ShipmentsPage extends ConsumerWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentsState = ref.watch(shipmentListViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(title: 'My Shipments', showBackButton: false),
          Expanded(
            child: shipmentsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _ShipmentsErrorView(
                message: error.toString(),
                onRetry: () =>
                    ref.read(shipmentListViewModelProvider.notifier).refresh(),
              ),
              data: (groups) => RefreshIndicator(
                onRefresh: () =>
                    ref.read(shipmentListViewModelProvider.notifier).refresh(),
                child: _ShipmentListContent(groups: groups),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShipmentListContent extends StatelessWidget {
  const _ShipmentListContent({required this.groups});

  final ShipmentListGroups groups;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg - 4),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        const SizedBox(height: AppSpacing.md),
        _ShipmentSummaryCard(
          total: groups.totalCount,
          active: groups.activeCount,
          needsAttention: groups.needsAttentionCount,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (groups.isEmpty)
          const _EmptyShipmentsView()
        else ...[
          if (groups.pending.isNotEmpty ||
              groups.invoiced.isNotEmpty ||
              groups.booked.isNotEmpty)
            AppAccordionSection(
              label: 'ACTIVE SHIPMENTS',
              children: [
                if (groups.pending.isNotEmpty)
                  ShipmentAccordionTile(
                    title: 'Pending Requests',
                    items: groups.pending,
                    accentColor: AppColors.primary,
                    icon: HugeIcons.strokeRoundedPackage,
                    initiallyExpanded: true,
                  ),
                if (groups.invoiced.isNotEmpty)
                  ShipmentAccordionTile(
                    title: 'Invoiced',
                    items: groups.invoiced,
                    accentColor: AppColors.success,
                    icon: HugeIcons.strokeRoundedInvoice01,
                  ),
                if (groups.booked.isNotEmpty)
                  ShipmentAccordionTile(
                    title: 'Booked',
                    items: groups.booked,
                    accentColor: AppColors.primary,
                    icon: HugeIcons.strokeRoundedDeliveryBox01,
                  ),
              ],
            ),
          if (groups.standby.isNotEmpty)
            AppAccordionSection(
              label: 'ACTION REQUIRED',
              children: [
                ShipmentAccordionTile(
                  title: 'Standby',
                  items: groups.standby,
                  accentColor: AppColors.warning,
                  icon: HugeIcons.strokeRoundedAlertCircle,
                ),
              ],
            ),
          if (groups.cancelled.isNotEmpty)
            AppAccordionSection(
              label: 'ARCHIVED',
              bottomSpacing: 100,
              children: [
                ShipmentAccordionTile(
                  title: 'Cancelled',
                  items: groups.cancelled,
                  accentColor: AppColors.error,
                  icon: HugeIcons.strokeRoundedCancel01,
                ),
              ],
            ),
        ],
      ],
    );
  }
}

class _EmptyShipmentsView extends StatelessWidget {
  const _EmptyShipmentsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedPackage,
            color: AppColors.neutral200,
            size: 52,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No shipments yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Create your first shipment request to track it here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Add Shipment',
            onPressed: () => context.push(AppRoutes.addShipment),
          ),
        ],
      ),
    );
  }
}

class _ShipmentsErrorView extends StatelessWidget {
  const _ShipmentsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlertCircle,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Unable to load shipments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(text: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

/// Always-visible overview banner showing aggregate shipment statistics.
///
/// Displays [total], [active] and [needsAttention] counts as tinted stat chips
/// inside a white card — ensures the page always has meaningful content above
/// the fold regardless of accordion expand/collapse state.
class _ShipmentSummaryCard extends StatelessWidget {
  const _ShipmentSummaryCard({
    required this.total,
    required this.active,
    required this.needsAttention,
  });

  final int total;
  final int active;
  final int needsAttention;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg - 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header row
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedPackage,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipment Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral900,
                    ),
                  ),
                  Text(
                    '$total shipments tracked',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md + 4),

          // Stat chips row
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'Total',
                  value: total.toString(),
                  color: AppColors.secondary,
                  icon: HugeIcons.strokeRoundedLayerMask01,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatChip(
                  label: 'Active',
                  value: active.toString(),
                  color: AppColors.primary,
                  icon: HugeIcons.strokeRoundedDeliveryBox01,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatChip(
                  label: 'Attention',
                  value: needsAttention.toString(),
                  color: AppColors.warning,
                  icon: HugeIcons.strokeRoundedAlertCircle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual stat chip inside [_ShipmentSummaryCard].
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm + 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: color, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
