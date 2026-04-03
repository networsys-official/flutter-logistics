import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';
import 'package:logistic_by_strom/core/models/dashboard_snapshot.dart';
import 'package:logistic_by_strom/core/models/shipment.dart';
import 'package:logistic_by_strom/features/dashboard/presentation/view_models/dashboard_view_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading && viewModel.snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null && viewModel.snapshot == null) {
          return _DashboardError(
            message: viewModel.errorMessage!,
            onRetry: () => context.read<DashboardViewModel>().load(),
          );
        }

        final DashboardSnapshot snapshot = viewModel.snapshot!;
        final textTheme = Theme.of(context).textTheme;

        return RefreshIndicator(
          onRefresh: () =>
              context.read<DashboardViewModel>().load(refresh: true),
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.space3),
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.space5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.ink900, AppColors.ocean600],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Operations command',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      snapshot.bannerTitle,
                      style: textTheme.displayLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space3),
                    Text(
                      snapshot.bannerMessage,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Wrap(
                      spacing: AppTheme.space2,
                      runSpacing: AppTheme.space2,
                      children: [
                        _HeroBadge(
                          label: 'Active',
                          value: '${snapshot.activeShipments}',
                        ),
                        _HeroBadge(
                          label: 'Delayed',
                          value: '${snapshot.delayedShipments}',
                        ),
                        _HeroBadge(
                          label: 'On-time',
                          value: '${snapshot.onTimeRate}%',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.space3),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Completed today',
                      value: '${snapshot.completedToday}',
                      tone: AppColors.success500,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space2),
                  Expanded(
                    child: _MetricCard(
                      title: 'Refresh status',
                      value: viewModel.isRefreshing ? 'Syncing' : 'Live',
                      tone: AppColors.ocean500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space3),
              Text('Priority board', style: textTheme.titleLarge),
              const SizedBox(height: AppTheme.space2),
              ...snapshot.highlightedShipments.map(_ShipmentCard.new),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.space3),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.all(AppTheme.space2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.tone,
  });

  final String title;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
            ),
            const SizedBox(height: AppTheme.space3),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  const _ShipmentCard(this.shipment);

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color statusColor = switch (shipment.status) {
      ShipmentStatus.delayed => AppColors.danger500,
      ShipmentStatus.delivered => AppColors.success500,
      ShipmentStatus.readyForDispatch => AppColors.gold500,
      ShipmentStatus.scheduled => AppColors.ink500,
      ShipmentStatus.inTransit => AppColors.ocean500,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(shipment.id, style: textTheme.titleMedium),
                  ),
                  Chip(
                    label: Text(shipment.statusLabel),
                    backgroundColor: statusColor.withValues(alpha: 0.12),
                    labelStyle: textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(shipment.clientName, style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(shipment.routeLabel, style: textTheme.bodyMedium),
              const SizedBox(height: AppTheme.space3),
              LinearProgressIndicator(
                value: shipment.progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(999),
                backgroundColor: AppColors.cloud200,
                color: statusColor,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(shipment.etaLabel, style: textTheme.bodyMedium),
                  const Spacer(),
                  Text(
                    shipment.priorityLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
