import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/shipment_detail_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/payment_webview_page.dart';

class ShipmentDetailPage extends ConsumerStatefulWidget {
  final ShipmentRequestModel shipment;

  const ShipmentDetailPage({super.key, required this.shipment});

  @override
  ConsumerState<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends ConsumerState<ShipmentDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch invoice details if shipment is invoiced but invoice data is missing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.shipment.bookingStatus.toLowerCase() == 'invoiced' &&
          widget.shipment.invoice == null) {
        ref
            .read(shipmentDetailViewModelProvider(widget.shipment).notifier)
            .fetchInvoice();
      }
    });

      debugPrint('Shipment ID: ${widget.shipment.id}');
      debugPrint('Booking Status: ${widget.shipment.bookingStatus}');
      debugPrint('Payment Status: ${widget.shipment.paymentStatus}');
      debugPrint('Request Number: ${widget.shipment.requestNumber}');
      debugPrint('Invoice: ${widget.shipment.invoice}');

  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shipmentDetailViewModelProvider(widget.shipment));
    final viewModel = ref.read(
      shipmentDetailViewModelProvider(widget.shipment).notifier,
    );

    // Listen for payment response to navigate to WebView
    ref.listen(shipmentDetailViewModelProvider(widget.shipment), (previous, next) {
      if (next.paymentResponse != null &&
          previous?.paymentResponse != next.paymentResponse) {
        _navigateToPayment(next.paymentResponse!.data.checkoutUrl);
      }
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error),
        );
        viewModel.clearError();
      }
    });

    final showPayButton =
        state.shipment.bookingStatus.toLowerCase() == 'invoiced' &&
        state.shipment.paymentStatus.toLowerCase() == 'unpaid' &&
        state.invoice != null;

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
                  _buildHeader(state.shipment),
                  const SizedBox(height: 32),
                  if (state.isLoadingInvoice)
                    const Center(child: CircularProgressIndicator())
                  else if (state.invoice != null) ...[
                    _buildSectionTitle('Invoice Information'),
                    const SizedBox(height: 16),
                    _buildInvoiceSection(state.invoice!),
                    const SizedBox(height: 32),
                  ],
                  _buildSectionTitle('General Information'),
                  const SizedBox(height: 16),
                  _buildGeneralInformation(state.shipment),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Item Details'),
                  const SizedBox(height: 16),
                  _buildItemsDetails(state.shipment),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Attachments'),
                  const SizedBox(height: 16),
                  _buildImagePreview(state.shipment),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          showPayButton
              ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: AppButton(
                  text: 'Pay Now (${state.invoice!.totalAmount} ${state.invoice!.currencyCode})',
                  isLoading: state.isInitiatingPayment,
                  onPressed: () => _showPaymentMethodSelector(context, viewModel),
                ),
              )
              : null,
    );
  }

  void _navigateToPayment(String url) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentWebViewPage(url: url, title: 'Secure Payment'),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      // Refresh invoice status if payment was successful
      ref
          .read(shipmentDetailViewModelProvider(widget.shipment).notifier)
          .fetchInvoice();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment completed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showPaymentMethodSelector(
    BuildContext context,
    ShipmentDetailViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.payment, color: AppColors.primary),
                  title: const Text('PayPal'),
                  subtitle: const Text('Pay securely with your PayPal account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.initiatePayment('paypal');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.credit_card, color: AppColors.secondary),
                  title: const Text('Fygaro'),
                  subtitle: const Text('Pay with Credit/Debit card'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.initiatePayment('fygaro');
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildInvoiceSection(dynamic invoice) {
    final currencyFormat = NumberFormat.currency(
      symbol: invoice.currencyCode,
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        children: [
          _InfoBlock(
            icon: Icons.receipt_long_outlined,
            label: 'Invoice Number',
            value: invoice.invoiceNumber,
          ),
          const SizedBox(height: 16),
          _InfoBlock(
            icon: Icons.calendar_today_outlined,
            label: 'Issued At',
            value: invoice.issuedAt,
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(color: AppColors.neutral500)),
              Text(currencyFormat.format(invoice.subtotal)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tax', style: TextStyle(color: AppColors.neutral500)),
              Text(currencyFormat.format(invoice.taxAmount)),
            ],
          ),
          if (invoice.discountAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount', style: TextStyle(color: AppColors.error)),
                Text(
                  '-${currencyFormat.format(invoice.discountAmount)}',
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Text(
                currencyFormat.format(invoice.totalAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ShipmentRequestModel shipment) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  Widget _buildGeneralInformation(ShipmentRequestModel shipment) {
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
            value:
                shipment.supplierTrackingNumber?.isNotEmpty == true
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

  Widget _buildItemsDetails(ShipmentRequestModel shipment) {
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
                child: _InfoBlock(label: 'Total Quantity', value: '$totalQuantity'),
              ),
              Expanded(
                child: _InfoBlock(
                  label: 'Service Type',
                  value:
                      shipment.serviceType?.isNotEmpty == true
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
                child: _InfoBlock(label: 'Payment Status', value: shipment.paymentStatus),
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

  Widget _buildImagePreview(ShipmentRequestModel shipment) {
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
                  final fullUrl = doc.resolvedFileUrl;
                  if (fullUrl == null) return const SizedBox.shrink();

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
