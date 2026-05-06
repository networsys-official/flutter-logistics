import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/add_shipment_form.dart';

class AddShipmentPage extends StatelessWidget {
  const AddShipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          _buildAppBar(context),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.lg),
                  AddShipmentForm(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.neutral100,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: AppColors.neutral900,
              ),
              const SizedBox(width: 8),
              Text(
                'Incoming Package',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              _buildNotificationIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Badge(
          label: Text('2'),
          backgroundColor: AppColors.error,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: AppColors.neutral900,
            size: 24,
          ),
        ),
      ),
    );
  }
}
