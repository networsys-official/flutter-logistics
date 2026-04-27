import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/constants/strings/account_strings.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/accounts_view_model.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          AccountStrings.accountTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: accountState.when(
        data: (profile) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildBody(context, ref, profile),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, UserProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(profile),
          const SizedBox(height: 24),
          _buildSectionHeader(AccountStrings.personalInfo),
          _buildMenuTile(
            icon: Icons.person_outline,
            title: AccountStrings.profileSection,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.email_outlined,
            title: AccountStrings.email,
            subtitle: profile?.email,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.phone_outlined,
            title: AccountStrings.phone,
            subtitle: profile?.phone,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AccountStrings.settingsSection),
          _buildMenuTile(
            icon: Icons.notifications_none_outlined,
            title: AccountStrings.notifications,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.lock_outline,
            title: AccountStrings.security,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.language_outlined,
            title: AccountStrings.language,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AccountStrings.supportSection),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: AccountStrings.helpCenter,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.policy_outlined,
            title: AccountStrings.privacyPolicy,
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
          const SizedBox(height: 80), // Extra space for bottom nav & FAB
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserProfile? profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.secondaryContainer,
            backgroundImage: profile?.profileImageUrl != null
                ? NetworkImage(profile!.profileImageUrl!)
                : null,
            child: profile?.profileImageUrl == null
                ? const Icon(Icons.person, size: 40, color: AppColors.secondary)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.neutral900,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.neutral700, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral900,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.neutral500),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: AppColors.neutral200),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: const Text(
          AccountStrings.logout,
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AccountStrings.logoutConfirmTitle),
        content: const Text(AccountStrings.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AccountStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              // Handle logout logic
              Navigator.pop(context);
            },
            child: const Text(
              AccountStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
