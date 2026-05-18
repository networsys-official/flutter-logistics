// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_accordion.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';

/// A shipment-group accordion tile.
///
/// Wraps [AppAccordion] and renders a list of [ShipmentRequestModel] items
/// as tappable rows inside the expanded body. Derives a subtitle preview
/// from the most recent item so the header is descriptive even when collapsed.
class ShipmentAccordionTile extends StatelessWidget {
  const ShipmentAccordionTile({
    super.key,
    required this.title,
    required this.items,
    required this.accentColor,
    required this.icon,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<ShipmentRequestModel> items;
  final Color accentColor;
  final dynamic icon;
  final bool initiallyExpanded;

  /// Returns a short preview subtitle built from the most recent item.
  String _buildSubtitle() {
    if (items.isEmpty) return '';
    final latest = items.first;
    final date = DateTime.tryParse(latest.requestedAt);
    final relativeDate = _relativeDate(date);
    return '${latest.supplierName} · $relativeDate';
  }

  String _relativeDate(DateTime? date) {
    if (date == null) return '—';
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AppAccordion(
      title: title,
      subtitle: _buildSubtitle(),
      accentColor: accentColor,
      leadingIcon: icon,
      badge: items.length.toString(),
      initiallyExpanded: initiallyExpanded,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: items
            .map((item) => _ShipmentRow(item: item, accentColor: accentColor))
            .toList(),
      ),
    );
  }
}

// ── Private row widget ──────────────────────────────────────────────────────

/// A single tappable row for a [ShipmentRequestModel] inside an accordion body.
class _ShipmentRow extends StatelessWidget {
  const _ShipmentRow({required this.item, required this.accentColor});

  final ShipmentRequestModel item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(item.requestedAt);
    final formattedDate = date != null
        ? DateFormat('dd MMM, yyyy').format(date)
        : item.requestedAt;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.shipmentDetail, extra: item),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.neutral100)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Request number + status badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.requestNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.neutral900,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _ShipmentStatusBadge(status: item.bookingStatus),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Supplier + date
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedStore01,
                          color: AppColors.neutral500,
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${item.supplierName} · $formattedDate',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.neutral500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Rate line
                    if (item.ratePerLb != null) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedTag01,
                            color: AppColors.primary,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${item.currencyCode ?? 'BSD'} ${item.ratePerLb}/lb',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.neutral200,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small colored pill badge showing the shipment booking status.
class _ShipmentStatusBadge extends StatelessWidget {
  const _ShipmentStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);
    final label = status.replaceAll('_', ' ').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Color _colorFor(String status) {
    return switch (status) {
      'pending' => AppColors.primary,
      'invoiced' => AppColors.success,
      'standby' => AppColors.warning,
      'cancelled' => AppColors.error,
      'booked' => AppColors.primary,
      _ => AppColors.neutral500,
    };
  }
}
