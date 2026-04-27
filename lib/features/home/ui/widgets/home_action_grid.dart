import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/constants/strings/home_strings.dart';

/// A grid of 4 quick-action items displayed in a white card.
class HomeActionGrid extends StatelessWidget {
  const HomeActionGrid({super.key});

  static const List<_ActionData> _actions = [
    _ActionData(
      icon: Icons.receipt_long_rounded,
      label: HomeStrings.invoice,
      color: AppColors.error,
      bgColor: Color(0xFFFBECEC),
    ),
    _ActionData(
      icon: Icons.timer_outlined,
      label: HomeStrings.standBy,
      color: AppColors.secondary,
      bgColor: Color(0xFFD6EEF4),
    ),
    _ActionData(
      icon: Icons.cancel_outlined,
      label: HomeStrings.cancelled,
      color: AppColors.warning,
      bgColor: Color(0xFFFFF0D9),
    ),
    _ActionData(
      icon: Icons.calculate_outlined,
      label: HomeStrings.calculator,
      color: AppColors.info,
      bgColor: Color(0xFFFFF8E1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _actions
            .map((action) => _ActionItem(data: action))
            .toList(),
      ),
    );
  }
}

class _ActionData {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _ActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });
}

class _ActionItem extends StatelessWidget {
  final _ActionData data;

  const _ActionItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
