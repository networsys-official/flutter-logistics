import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/constants/strings/home_strings.dart';

/// A grid of 4 quick-action items displayed in a white card.
class HomeActionGrid extends StatelessWidget {
  const HomeActionGrid({super.key});

  static const List<_ActionData> _actions = [
    _ActionData(
      icon: HugeIcons.strokeRoundedInvoice01,
      label: HomeStrings.invoice,
      color: AppColors.error,
      bgColor: AppColors.errorContainer,
    ),
    _ActionData(
      icon: HugeIcons.strokeRoundedClock01,
      label: HomeStrings.standBy,
      color: AppColors.secondary,
      bgColor: AppColors.infoContainer,
    ),
    _ActionData(
      icon: HugeIcons.strokeRoundedCancel01,
      label: HomeStrings.cancelled,
      color: AppColors.warning,
      bgColor: AppColors.warningContainer,
    ),
    _ActionData(
      icon: HugeIcons.strokeRoundedCalculator,
      label: HomeStrings.calculator,
      color: AppColors.info,
      bgColor: AppColors.goldContainer,
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
        children: _actions.map((action) => _ActionItem(data: action)).toList(),
      ),
    );
  }
}

class _ActionData {
  final dynamic icon;
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
      onTap: () {
        if (data.label == HomeStrings.invoice) {
          context.push('${AppRoutes.statusRequests}?status=invoiced');
        } else if (data.label == HomeStrings.standBy) {
          context.push('${AppRoutes.statusRequests}?status=standby');
        } else if (data.label == HomeStrings.cancelled) {
          context.push('${AppRoutes.statusRequests}?status=cancelled');
        } else if (data.label == HomeStrings.calculator) {
          context.push(AppRoutes.calculator);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.bgColor,
              shape: BoxShape.circle,
            ),
            child: HugeIcon(icon: data.icon, color: data.color, size: 28),
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
