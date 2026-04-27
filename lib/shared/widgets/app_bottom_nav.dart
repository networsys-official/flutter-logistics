import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistic_by_strom/core/constants/enums/app_tabs.dart';
import 'package:logistic_by_strom/core/constants/strings/menu_strings.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    onTap(index);
  }

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
            label: MenuStrings.home,
            isActive: currentIndex == AppTab.home.index,
            onTap: () => _handleTap(AppTab.home.index),
          ),
          _NavItem(
            icon: Icons.local_shipping_outlined,
            label: MenuStrings.shipping,
            isActive: currentIndex == AppTab.shipments.index,
            onTap: () => _handleTap(AppTab.shipments.index),
          ),
          const SizedBox(width: 48), // FAB Spacer
          _NavItem(
            icon: Icons.headset_mic_outlined,
            label: MenuStrings.support,
            isActive: currentIndex == AppTab.support.index,
            onTap: () => _handleTap(AppTab.support.index),
          ),
          _NavItem(
            icon: Icons.person_2_outlined,
            label: MenuStrings.profile,
            isActive: currentIndex == AppTab.account.index,
            onTap: () => _handleTap(AppTab.account.index),
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
    
    return Semantics(
      label: label,
      selected: isActive,
      button: true,
      child: GestureDetector(
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
      ),
    );
  }
}
