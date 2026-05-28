import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:logistic_by_strom/core/constants/strings/home_strings.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/home/ui/view_models/home_view_model.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_action_grid.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_banner_carousel.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_section_header.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/shipment_card.dart';
import 'package:logistic_by_strom/features/shipments/data/models/user_shipment_model.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  int _mapStatusToStepIndex(UserShipmentStatus status) {
    switch (status) {
      case UserShipmentStatus.pending:
        return 0;
      case UserShipmentStatus.receivedAtOrigin:
      case UserShipmentStatus.dispatched:
        return 1;
      case UserShipmentStatus.inTransit:
      case UserShipmentStatus.arrivedAtDestination:
        return 2;
      case UserShipmentStatus.outForDelivery:
      case UserShipmentStatus.delivered:
        return 3;
      default:
        return 0;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat.yMMMd().format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final authState = ref.watch(authProvider);
    final userName = authState.value?.user?.name ?? 'User Name';

    return homeState.when(
      loading: () => Skeletonizer(
        enabled: true,
        child: _buildHomeContent(
          context: context,
          ref: ref,
          userName: userName,
          currentShipment: const UserShipmentModel(
            id: 0,
            trackingNumber: 'HWDSF776567DS',
            currentStatus: UserShipmentStatus.inTransit,
            createdAt: '2026-03-30T15:10:41+05:30',
          ),
          recentShipments: const [
            UserShipmentModel(
              id: 1,
              trackingNumber: 'BAH99228834XL',
              currentStatus: UserShipmentStatus.delivered,
              createdAt: '2026-03-28T15:10:41+05:30',
            ),
          ],
          onRefresh: () async {},
        ),
      ),
      error: (err, stack) => RefreshIndicator(
        onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load shipments: $err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.neutral700, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.read(homeViewModelProvider.notifier).refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (state) => Skeletonizer(
        enabled: false,
        child: _buildHomeContent(
          context: context,
          ref: ref,
          userName: userName,
          currentShipment: state.currentShipment,
          recentShipments: state.recentShipments,
          onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildHomeContent({
    required BuildContext context,
    required WidgetRef ref,
    required String userName,
    UserShipmentModel? currentShipment,
    required List<UserShipmentModel> recentShipments,
    required Future<void> Function() onRefresh,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName! 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Track your cargo and packages in real-time.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Quick-action grid
          const HomeActionGrid(),

          const SizedBox(height: 24),

          // Promotional banner carousel
          const HomeBannerCarousel(),

          const SizedBox(height: 24),

          // Current shipment section
          if (currentShipment != null) ...[
            HomeSectionHeader(
              title: HomeStrings.currentShipment,
              onViewAll: () => context.push(AppRoutes.orders),
            ),
            ShipmentCard(
              title: 'Current',
              id: '#${currentShipment.trackingNumber}',
              status: currentShipment.currentStatus.label,
              date: _formatDate(currentShipment.createdAt),
              showTimeline: true,
              originCountry: currentShipment.originCountry?.name ?? 'USA',
              destinationCountry: currentShipment.destinationCountry?.name ?? 'Bahamas',
              activeStepIndex: _mapStatusToStepIndex(currentShipment.currentStatus),
              onTap: () => context.push(AppRoutes.orders),
            ),
            const SizedBox(height: 24),
          ],

          // Recent shipments section
          if (recentShipments.isNotEmpty) ...[
            HomeSectionHeader(
              title: HomeStrings.recentShipments,
              onViewAll: () => context.push(AppRoutes.orders),
            ),
            ...recentShipments.take(currentShipment == null ? 3 : 2).map((shipment) {
              return ShipmentCard(
                title: 'Recent',
                id: '#${shipment.trackingNumber}',
                status: shipment.currentStatus.label,
                date: _formatDate(shipment.createdAt),
                showTimeline: false,
                onTap: () => context.push(AppRoutes.orders),
              );
            }),
          ],

          if (currentShipment == null && recentShipments.isEmpty) ...[
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.neutral100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 32,
                      color: AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No shipments found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Create a shipment request to track it here.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Extra bottom padding so FAB doesn't obscure content
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}
