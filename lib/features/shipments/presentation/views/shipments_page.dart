import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';
import 'package:logistic_by_strom/core/models/shipment.dart';
import 'package:logistic_by_strom/features/shipments/presentation/view_models/shipments_view_model.dart';

class ShipmentsPage extends StatelessWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShipmentsViewModel>(
      builder: (context, viewModel, _) {
        final textTheme = Theme.of(context).textTheme;

        return RefreshIndicator(
          onRefresh: () =>
              context.read<ShipmentsViewModel>().load(refresh: true),
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.space3),
            children: [
              Text('Shipment board', style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Feature-based MVVM keeps screen logic in the view model while the repository remains the single source of truth.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppTheme.space3),
              TextField(
                onChanged: context.read<ShipmentsViewModel>().updateQuery,
                decoration: const InputDecoration(
                  hintText: 'Search by shipment, route, or client',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: AppTheme.space3),
              if (viewModel.isLoading && viewModel.shipments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppTheme.space5),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (viewModel.errorMessage != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.space4),
                    child: Text(viewModel.errorMessage!),
                  ),
                )
              else ...[
                Text(
                  '${viewModel.visibleShipments.length} results',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.space2),
                ...viewModel.visibleShipments.map(_ShipmentListTile.new),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ShipmentListTile extends StatelessWidget {
  const _ShipmentListTile(this.shipment);

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final Color accent = switch (shipment.status) {
      ShipmentStatus.delayed => AppColors.danger500,
      ShipmentStatus.delivered => AppColors.success500,
      ShipmentStatus.readyForDispatch => AppColors.gold500,
      ShipmentStatus.scheduled => AppColors.ink500,
      ShipmentStatus.inTransit => AppColors.ocean500,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space2),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          leading: CircleAvatar(
            backgroundColor: accent.withValues(alpha: 0.14),
            foregroundColor: accent,
            child: const Icon(Icons.inventory_2_rounded),
          ),
          title: Text(shipment.id),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('${shipment.clientName}\n${shipment.routeLabel}'),
          ),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                shipment.statusLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: accent),
              ),
              const SizedBox(height: 4),
              Text(
                shipment.etaLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
