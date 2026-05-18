import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';

class ShipmentDetailPage extends StatelessWidget {
  final ShipmentRequestModel shipment;

  const ShipmentDetailPage({super.key, required this.shipment});

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
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('General Information'),
                  const SizedBox(height: 16),
                  _buildGeneralInformation(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Item Details'),
                  const SizedBox(height: 16),
                  _buildItemsDetails(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Attachments'),
                  const SizedBox(height: 16),
                  _buildImagePreview(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedDeliveryTruck01,
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shipment.requestNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    shipment.bookingStatus,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.neutral900,
        ),
      ),
    );
  }

  Widget _buildGeneralInformation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        children: [
          _InfoBlock(
            icon: Icons.storefront_outlined,
            label: 'Supplier',
            value: shipment.supplierName,
          ),
          const SizedBox(height: 24),
          _InfoBlock(
            icon: Icons.pin_drop_outlined,
            label: 'Tracking No',
            value: shipment.supplierTrackingNumber?.isNotEmpty == true
                ? shipment.supplierTrackingNumber!
                : 'N/A',
          ),
          const SizedBox(height: 24),
          _InfoBlock(
            icon: Icons.public_outlined,
            label: 'Delivery Type',
            value: shipment.deliveryType,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsDetails() {
    final currencyFormat = NumberFormat.currency(
      symbol: shipment.currencyCode ?? '\$',
      decimalDigits: 2,
    );

    final totalValue =
        shipment.items?.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        ) ??
        0.0;

    final totalQuantity =
        shipment.items?.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;

    final commodityTypes =
        shipment.items
            ?.map((e) => e.commodityType ?? 'Unknown')
            .where((e) => e.isNotEmpty)
            .toSet()
            .join(', ') ??
        'N/A';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoBlock(
            icon: Icons.inventory_2_outlined,
            label: 'Commodities',
            value: commodityTypes.isEmpty ? 'N/A' : commodityTypes,
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _InfoBlock(
                  label: 'Total Quantity',
                  value: '$totalQuantity',
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: 'Service Type',
                  value: shipment.serviceType?.isNotEmpty == true
                      ? shipment.serviceType!
                      : 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _InfoBlock(
                  label: 'Payment Status',
                  value: shipment.paymentStatus,
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: 'Declared Value',
                  value: currencyFormat.format(totalValue),
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    final documents = shipment.documents ?? [];
    final hasImages = documents.any((doc) => doc.fileUrl != null);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.neutral700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Invoice / Package Image',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!hasImages)
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.neutral200, width: 1.5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No image uploaded yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: documents.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  if (doc.fileUrl == null) return const SizedBox.shrink();

                  final fullUrl = doc.fileUrl!.startsWith('http')
                      ? doc.fileUrl!
                      : '${ApiEndpoints.storageBaseUrl}${doc.fileUrl}';

                  return Container(
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      fullUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.error,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Failed to load',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoBlock({
    this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon!, color: AppColors.neutral700, size: 22),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? AppColors.neutral900,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
