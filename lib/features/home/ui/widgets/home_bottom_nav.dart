import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

/// Bottom navigation bar with a notched FAB slot in the center.
/// Tabs: Home | Order | [FAB] | Support | Account
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      color: AppColors.white,
      elevation: 12,
      shadowColor: AppColors.neutral900.withValues(alpha: 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_filled,
            label: 'Home',
            isActive: true,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.local_shipping_outlined,
            label: 'Order',
            onTap: () {},
          ),
          // FAB spacer
          const SizedBox(width: 48),
          _NavItem(
            icon: Icons.headset_mic_outlined,
            label: 'Support',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.person_2_outlined,
            label: 'Account',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.neutral500;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
