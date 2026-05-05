import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildFAQTile(
                  context,
                  'How can I track my shipment?',
                  'You can track your shipment by entering your tracking ID on the home screen or by visiting the "Shipments" tab in the bottom navigation menu.',
                ),
                _buildFAQTile(
                  context,
                  'What are the shipping rates?',
                  'Shipping rates vary based on the item dimensions, weight, and delivery location. You can use our "Calculator" tool to get an instant estimate.',
                ),
                _buildFAQTile(
                  context,
                  'How do I update my profile?',
                  'Go to the "Account" tab and tap the "Edit" icon on your profile card. You can update your name, email, and phone number there.',
                ),
                _buildFAQTile(
                  context,
                  'What payment methods are accepted?',
                  'We accept major credit/debit cards, bank transfers, and popular digital wallets. You can manage your payment methods in the settings section.',
                ),
                _buildFAQTile(
                  context,
                  'How do I contact support?',
                  'Visit the "Support" tab in the bottom navigation menu. You can find our phone number, email address, and head office location there.',
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
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
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: AppColors.neutral900,
              ),
              const SizedBox(width: 8),
              Text(
                'FAQ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.5)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.neutral700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
