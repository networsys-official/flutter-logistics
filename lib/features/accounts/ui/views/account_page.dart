import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/accounts_view_model.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';

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

  Widget _buildContent(BuildContext context, WidgetRef ref, UserProfile? profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeader(context, profile),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildStatusBanner(),
                const SizedBox(height: AppSpacing.xl),
                _buildSectionHeader('Account Settings'),
                _buildMenuContainer([
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedUser,
                    title: 'Account Information',
                    onTap: () => context.push(AppRoutes.editProfile),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedKey01,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedSmartPhone01,
                    title: 'Device',
                    onTap: () {},
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedBank,
                    title: 'Connect to Banks',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: AppSpacing.xl),
                _buildSectionHeader('Settings'),
                _buildMenuContainer([
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedSettings01,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    title: 'Help & Support',
                    onTap: () => context.push(AppRoutes.support),
                  ),
                  _MenuAction(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    title: 'About',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: AppSpacing.xl),
                _buildLogoutButton(context, ref),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile? profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        60,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F5E9), // Light green tint
            AppColors.neutral100,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.secondaryContainer,
              backgroundImage: profile?.profileImageUrl != null
                  ? NetworkImage(profile!.profileImageUrl!)
                  : null,
              child: profile?.profileImageUrl == null
                  ? const Icon(Icons.person, size: 35, color: AppColors.secondary)
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
                Text(
                  profile?.email ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => context.push(AppRoutes.editProfile),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neutral200),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9C27B0), // Purple gradient like image but adapted
            Color(0xFF673AB7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF673AB7).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedStar,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Account',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Enjoy your premium features',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.white,
            size: 20,
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral500,
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<_MenuAction> actions) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: List.generate(actions.length, (index) {
          final action = actions[index];
          return Column(
            children: [
              ListTile(
                leading: HugeIcon(icon: action.icon, color: AppColors.neutral900, size: 22),
                title: Text(
                  action.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.neutral900,
                  ),
                ),
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.neutral200,
                  size: 20,
                ),
                onTap: action.onTap,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                visualDensity: VisualDensity.compact,
              ),
              if (index != actions.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
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
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.neutral500)),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w800)),
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

  const _MenuAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
