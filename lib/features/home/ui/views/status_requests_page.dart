import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/home/ui/view_models/status_requests_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/shipment_detail_view_model.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/payment_webview_page.dart';
import 'package:logistic_by_strom/core/utils/file_utils.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';

class StatusRequestsPage extends ConsumerWidget {
  final String status;

  const StatusRequestsPage({super.key, required this.status});

  String _getTitle() {
    switch (status.toLowerCase()) {
      case 'invoiced':
        return 'Waiting for Payment';
      case 'standby':
        return 'Standby Requests';
      case 'cancelled':
        return 'Cancelled Requests';
      default:
        return '${status[0].toUpperCase()}${status.substring(1)} Requests';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(statusRequestsViewModelProvider(status));

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          AppAppBar(title: _getTitle()),
          Expanded(
            child: listState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading requests: $err',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(
                              statusRequestsViewModelProvider(status).notifier,
                            )
                            .refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (requests) {
                if (requests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedChat01,
                            color: AppColors.neutral500,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ${_getTitle().toLowerCase()} found',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Render in conversational order (newest at bottom)
                final sortedRequests = List<ShipmentRequestModel>.from(requests)
                  ..sort((a, b) => a.requestedAt.compareTo(b.requestedAt));

                return ListView.builder(
                  padding: const EdgeInsets.all(18),
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortedRequests.length,
                  itemBuilder: (context, index) {
                    final shipment = sortedRequests[index];
                    return _BubbleTimelineGroup(shipment: shipment);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTimelineGroup extends ConsumerWidget {
  final ShipmentRequestModel shipment;

  const _BubbleTimelineGroup({required this.shipment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Format timestamp
    String formattedTime = '';
    try {
      final parsed = DateTime.parse(shipment.requestedAt);
      formattedTime = DateFormat.jm().format(parsed);
    } catch (_) {
      formattedTime = shipment.requestedAt;
    }

    final itemsStr =
        shipment.items
            ?.map((e) => '${e.commodityType ?? 'Items'} (${e.quantity})')
            .join(', ') ??
        'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Timestamp Divider
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.neutral200.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral700,
              ),
            ),
          ),
        ),

        // Left Bubble: System/Supplier request details
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(right: 40),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shipment.requestNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Supplier: ${shipment.supplierName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Items: $itemsStr',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shipment.bookingStatus.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Left Bubble: Admin/System Standby Message
        if (shipment.bookingStatus.toLowerCase() == 'standby' &&
            shipment.standbyMessage != null) ...[
          _StandbyMessageBubble(message: shipment.standbyMessage!),
          const SizedBox(height: 12),
        ],

        // Right Bubble: Standby Upload Card
        if (shipment.bookingStatus.toLowerCase() == 'standby') ...[
          _StandbyUploadCard(shipment: shipment),
          const SizedBox(height: 12),
        ],

        // Right Bubble: Payment Card (only for invoiced requests)
        if (shipment.bookingStatus.toLowerCase() == 'invoiced')
          _PaymentBubbleCard(shipment: shipment),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _PaymentBubbleCard extends ConsumerStatefulWidget {
  final ShipmentRequestModel shipment;

  const _PaymentBubbleCard({required this.shipment});

  @override
  ConsumerState<_PaymentBubbleCard> createState() => _PaymentBubbleCardState();
}

class _PaymentBubbleCardState extends ConsumerState<_PaymentBubbleCard> {
  @override
  void initState() {
    super.initState();
    // Fetch details if invoice is missing
    if (widget.shipment.invoice == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(shipmentDetailViewModelProvider(widget.shipment).notifier)
            .fetchInvoice();
      });
    }
  }

  void _navigateToPayment(String url) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentWebViewPage(url: url, title: 'Secure Payment'),
      ),
    );

    if (!mounted) return;

    if (result == true) {
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
      builder: (context) => Container(
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
              leading: const Icon(
                Icons.credit_card,
                color: AppColors.secondary,
              ),
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

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(
      shipmentDetailViewModelProvider(widget.shipment),
    );
    final viewModel = ref.read(
      shipmentDetailViewModelProvider(widget.shipment).notifier,
    );

    // Listen to payment response to launch webview
    ref.listen(shipmentDetailViewModelProvider(widget.shipment), (
      previous,
      next,
    ) {
      if (next.paymentResponse != null &&
          previous?.paymentResponse != next.paymentResponse) {
        _navigateToPayment(next.paymentResponse!.data.checkoutUrl);
      }
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        viewModel.clearError();
      }
    });

    final invoice = detailState.invoice;
    final currency = invoice?.currencyCode ?? '\$';
    final amount = invoice?.totalAmount ?? '0.00';
    final isPaid = detailState.shipment.paymentStatus.toLowerCase() == 'paid';

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 40),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPaid ? AppColors.successContainer : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          border: Border.all(
            color: isPaid
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.neutral200,
          ),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaid ? Icons.check_circle_outline : Icons.payment_outlined,
                  color: isPaid ? AppColors.success : AppColors.warning,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isPaid ? 'Payment Received' : 'Payment Request',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? AppColors.success : AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$currency$amount',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isPaid ? AppColors.success : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPaid ? 'Thank you!' : 'Due upon receipt',
              style: const TextStyle(fontSize: 10, color: AppColors.neutral500),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: AppButton(
                text: isPaid ? 'Paid' : 'Pay Now',
                isLoading:
                    detailState.isInitiatingPayment ||
                    detailState.isLoadingInvoice,
                padding: const EdgeInsets.symmetric(vertical: 0),
                fontSize: 12.0,
                backgroundColor: isPaid ? AppColors.success : AppColors.primary,
                onPressed: isPaid
                    ? null
                    : () => _showPaymentMethodSelector(context, viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StandbyMessageBubble extends StatelessWidget {
  final String message;

  const _StandbyMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 40),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.neutral200.withValues(alpha: 0.4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                SizedBox(width: 6),
                Text(
                  'Support Message',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: AppColors.neutral700),
            ),
          ],
        ),
      ),
    );
  }
}

class _StandbyUploadCard extends ConsumerStatefulWidget {
  final ShipmentRequestModel shipment;

  const _StandbyUploadCard({required this.shipment});

  @override
  ConsumerState<_StandbyUploadCard> createState() => _StandbyUploadCardState();
}

class _StandbyUploadCardState extends ConsumerState<_StandbyUploadCard> {
  bool _isUploading = false;
  bool _hasUploaded = false;

  Future<void> _pickAndUploadInvoice({required bool fromCamera}) async {
    final file = fromCamera
        ? await FileUtils.captureFromCamera()
        : await FileUtils.pickDocument();

    if (file == null) return;

    final int sizeInBytes = await file.length();
    if (sizeInBytes > 4 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'File size exceeds the 4MB limit. Please upload a smaller file.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.uploadInvoice(widget.shipment.id, file);

    if (!mounted) return;

    setState(() {
      _isUploading = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (_) {
        setState(() {
          _hasUploaded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supplier invoice uploaded successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        ref.read(statusRequestsViewModelProvider('standby').notifier).refresh();
      },
    );
  }

  void _showSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Invoice Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo (Camera)'),
              subtitle: const Text('Capture receipt using your device camera'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadInvoice(fromCamera: true);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.folder_open,
                color: AppColors.secondary,
              ),
              title: const Text('Choose File (Storage)'),
              subtitle: const Text('Select a JPG, PNG, or PDF file'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadInvoice(fromCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasUploaded = _hasUploaded || widget.shipment.bookingStatus.toLowerCase() != 'standby';

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 40),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasUploaded ? AppColors.successContainer : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          border: Border.all(
            color: hasUploaded
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.neutral200,
          ),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasUploaded ? Icons.check_circle_outline : Icons.upload_file_outlined,
                  color: hasUploaded ? AppColors.success : AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  hasUploaded ? 'Invoice Uploaded' : 'Upload Action Required',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: hasUploaded ? AppColors.success : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasUploaded
                  ? 'The supplier invoice has been successfully updated.'
                  : 'Please upload a new correct supplier invoice to proceed.',
              style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: AppButton(
                text: hasUploaded ? 'Uploaded' : 'Upload Supplier Invoice',
                isLoading: _isUploading,
                padding: const EdgeInsets.symmetric(vertical: 0),
                fontSize: 12.0,
                backgroundColor: hasUploaded ? AppColors.success : AppColors.primary,
                onPressed: hasUploaded ? null : () => _showSourceSelector(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
