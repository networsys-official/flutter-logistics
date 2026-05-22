import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/accounts_view_model.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: accountState.when(
        data: (profile) => _buildContent(context, ref, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserProfile? profile,
  ) {
    return Column(
      children: [
        const AppAppBar(title: 'Account', showBackButton: false),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildProfileCard(context, profile),
                const SizedBox(height: AppSpacing.xl),
                _buildSectionHeader('Account Settings'),
                _buildMenuContainer([
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedUser,
                    title: 'Shipment Address',
                    onTap: () => context.push(AppRoutes.shipmentAddress),
                    color: AppColors.secondary,
                    bgColor: const Color(0xFFD6EEF4),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedKey01,
                    title: 'Update Password',
                    onTap: () => context.push(AppRoutes.updatePassword),
                    color: AppColors.primary,
                    bgColor: const Color(0xFFE8F5E9),
                  ),
                ]),
                const SizedBox(height: AppSpacing.xl),
                _buildSectionHeader('General'),
                _buildMenuContainer([
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedSettings01,
                    title: 'Settings',
                    onTap: () {},
                    color: AppColors.info,
                    bgColor: const Color(0xFFFFF8E1),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedCustomerService,
                    title: 'Help & Support',
                    onTap: () => context.push(AppRoutes.support),
                    color: AppColors.secondary,
                    bgColor: const Color(0xFFD6EEF4),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    title: 'FAQ',
                    onTap: () => context.push(AppRoutes.faq),
                    color: AppColors.primary,
                    bgColor: const Color(0xFFE8F5E9),
                  ),
                ]),
                const SizedBox(height: AppSpacing.xl),
                _buildSectionHeader('Legal'),
                _buildMenuContainer([
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedShield01,
                    title: 'Privacy Policy',
                    onTap: () => context.push(AppRoutes.privacyPolicy),
                    color: AppColors.secondary,
                    bgColor: const Color(0xFFD6EEF4),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedNote01,
                    title: 'Terms & Conditions',
                    onTap: () => context.push(AppRoutes.termsAndConditions),
                    color: AppColors.accent,
                    bgColor: const Color(0xFFFFF0D9),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    title: 'About',
                    onTap: () {},
                    color: AppColors.neutral700,
                    bgColor: AppColors.neutral200.withValues(alpha: 0.3),
                  ),
                ]),
                const SizedBox(height: AppSpacing.xl),
                _buildLogoutButton(context, ref),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile? profile) {
    final resolvedUrl = profile?.resolvedImageUrl;
    final ImageProvider imageProvider = (resolvedUrl != null && resolvedUrl.isNotEmpty)
        ? NetworkImage(resolvedUrl)
        : const AssetImage(AppImages.userProfile);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        boxShadow: AppSpacing.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neutral200),
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.secondaryContainer,
              backgroundImage: imageProvider,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? 'No email provided',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.editProfile),
            icon: const Icon(Icons.edit_outlined, size: 24),
            color: AppColors.neutral700,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<_MenuAction> actions) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        children: List.generate(actions.length, (index) {
          final action = actions[index];
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: action.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: action.icon,
                    color: action.color,
                    size: 20,
                  ),
                ),
                title: Text(
                  action.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.neutral900,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.neutral200,
                  size: 14,
                ),
                onTap: action.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
              if (index != actions.length - 1)
                Divider(
                  height: 1,
                  indent: 64,
                  endIndent: 20,
                  color: AppColors.neutral200.withValues(alpha: 0.5),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: TextButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.neutral500),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuAction {
  final dynamic icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  final Color bgColor;

  const _MenuAction({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
    required this.bgColor,
  });
}
