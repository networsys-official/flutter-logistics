import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/shared/widgets/app_app_bar.dart';

class ShipmentsPage extends StatelessWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(
            title: 'Shipments',
            showBackButton: false,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildShipmentCard(
                  context,
                  id: '#HWDSF776567DS',
                  status: 'On the way',
                  date: '30 March',
                  supplier: 'Amazon USA',
                  color: AppColors.primary,
                  bgColor: const Color(0xFFE8F5E9),
                ),
                _buildShipmentCard(
                  context,
                  id: '#BAH99228834XL',
                  status: 'Delivered',
                  date: '28 March',
                  supplier: 'eBay UK',
                  color: AppColors.secondary,
                  bgColor: const Color(0xFFD6EEF4),
                ),
                _buildShipmentCard(
                  context,
                  id: '#KJL11223344ZZ',
                  status: 'Pending',
                  date: '02 April',
                  supplier: 'AliExpress',
                  color: AppColors.warning,
                  bgColor: const Color(0xFFFFF0D9),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(
    BuildContext context, {
    required String id,
    required String status,
    required String date,
    required String supplier,
    required Color color,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () => context.push(AppRoutes.shipmentDetail),
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedPackage,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$supplier • $date',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.neutral200,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                const Text(
                  '\$52.50',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
