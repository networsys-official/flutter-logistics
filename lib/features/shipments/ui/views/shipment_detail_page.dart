import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';

class ShipmentDetailPage extends StatelessWidget {
  const ShipmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(title: 'Shipment Details'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _buildStatusHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Tracking Details'),
                  _buildTrackingTimeline(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Package Information'),
                  _buildPackageDetails(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Payment Summary'),
                  _buildPaymentSummary(),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedDeliveryTruck01,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '#HWDSF776567DS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'On the way',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            'Processed in USA',
            'March 30, 2024 • 10:30 AM',
            isCompleted: true,
          ),
          _buildTimelineDivider(isCompleted: true),
          _buildTimelineItem(
            'Shipped from USA',
            'March 31, 2024 • 02:15 PM',
            isCompleted: true,
          ),
          _buildTimelineDivider(isCompleted: true),
          _buildTimelineItem(
            'Arrived in Transit',
            'April 02, 2024 • 09:00 AM',
            isCompleted: true,
            isCurrent: true,
          ),
          _buildTimelineDivider(isCompleted: false),
          _buildTimelineItem(
            'Out for Delivery',
            'Pending',
            isCompleted: false,
          ),
          _buildTimelineDivider(isCompleted: false),
          _buildTimelineItem(
            'Delivered',
            'Estimated: April 05',
            isCompleted: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle,
      {bool isCompleted = false, bool isCurrent = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : AppColors.neutral200,
                  width: 2,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: AppColors.white)
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  color: isCurrent ? AppColors.neutral900 : (isCompleted ? AppColors.neutral900 : AppColors.neutral500),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineDivider({required bool isCompleted}) {
    return Container(
      margin: const EdgeInsets.only(left: 9, top: 4, bottom: 4),
      width: 2,
      height: 30,
      color: isCompleted ? AppColors.primary : AppColors.neutral200,
    );
  }

  Widget _buildPackageDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: const Column(
        children: [
          _InfoRow(label: 'Store/Supplier', value: 'Amazon USA'),
          Divider(height: 32),
          _InfoRow(label: 'Commodity', value: 'iPhone 15 Pro'),
          Divider(height: 32),
          _InfoRow(label: 'Weight', value: '0.8 kg'),
          Divider(height: 32),
          _InfoRow(label: 'Dimensions', value: '15 x 10 x 5 cm'),
          Divider(height: 32),
          _InfoRow(label: 'Service', value: 'Priority Shipping'),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        children: [
          const _InfoRow(label: 'Shipping Fee', value: '\$45.00'),
          const SizedBox(height: 12),
          const _InfoRow(label: 'Insurance', value: '\$5.00'),
          const SizedBox(height: 12),
          const _InfoRow(label: 'Tax', value: '\$2.50'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                ),
              ),
              const Text(
                '\$52.50',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFBECEC),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Text(
              'Unpaid',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          text: 'Pay Now',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.neutral500,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Report an Issue',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
      ],
    );
  }
}
