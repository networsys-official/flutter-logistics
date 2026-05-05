import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                    'Data Collection',
                    'We collect information to provide better services to all our users. This includes information you provide to us (like your name, email address, and telephone number) and information we get from your use of our services (like device information and location).',
                  ),
                  _buildSection(
                    context,
                    'How We Use Information',
                    'We use the information we collect from all our services to provide, maintain, protect and improve them, to develop new ones, and to protect Logistic by Strom and our users.',
                  ),
                  _buildSection(
                    context,
                    'Information We Share',
                    'We do not share personal information with companies, organizations and individuals outside of Logistic by Strom unless one of the following circumstances applies: With your consent, with domain administrators, for external processing, or for legal reasons.',
                  ),
                  _buildSection(
                    context,
                    'Information Security',
                    'We work hard to protect Logistic by Strom and our users from unauthorized access to or unauthorized alteration, disclosure or destruction of information we hold.',
                  ),
                  _buildSection(
                    context,
                    'Changes',
                    'Our Privacy Policy may change from time to time. We will not reduce your rights under this Privacy Policy without your explicit consent. We will post any privacy policy changes on this page.',
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
                'Privacy Policy',
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
