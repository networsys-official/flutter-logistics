import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _buildSection(
                    context,
                    'Introduction',
                    'Welcome to Logistic by Strom. By using our services, you agree to these terms. Please read them carefully. Our platform provides logistics and shipping services designed to streamline your business operations.',
                  ),
                  _buildSection(
                    context,
                    'Use of Services',
                    'You must follow any policies made available to you within the Services. Don’t misuse our Services. For example, don’t interfere with our Services or try to access them using a method other than the interface and the instructions that we provide.',
                  ),
                  _buildSection(
                    context,
                    'Your Account',
                    'You may need a Logistic by Strom Account in order to use some of our Services. You are responsible for the activity that happens on or through your Account. Try not to reuse your Account password on third-party applications.',
                  ),
                  _buildSection(
                    context,
                    'Privacy and Copyright Protection',
                    'Logistic by Strom’s privacy policies explain how we treat your personal data and protect your privacy when you use our Services. By using our Services, you agree that we can use such data in accordance with our privacy policies.',
                  ),
                  _buildSection(
                    context,
                    'Liability for our Services',
                    'When permitted by law, Logistic by Strom, and our suppliers and distributors, will not be responsible for lost profits, revenues, or data, financial losses or indirect, special, consequential, exemplary, or punitive damages.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
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
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: AppColors.neutral900,
              ),
              const SizedBox(width: 8),
              Text(
                'Terms & Conditions',
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

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral700,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
