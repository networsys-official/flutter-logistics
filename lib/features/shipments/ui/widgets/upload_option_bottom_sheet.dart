import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

enum DocumentPickerSource { camera, files }

class UploadOptionBottomSheet extends StatelessWidget {
  const UploadOptionBottomSheet({super.key, required this.onPick});

  final ValueChanged<DocumentPickerSource> onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select upload option',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 32),
          _UploadOptionTile(
            icon: HugeIcons.strokeRoundedCamera01,
            label: 'Take a photo',
            color: AppColors.primary,
            bgColor: Color(0xFFE8F5E9),
            onTap: () => onPick(DocumentPickerSource.camera),
          ),
          const SizedBox(height: 16),
          _UploadOptionTile(
            icon: HugeIcons.strokeRoundedFolder01,
            label: 'Choose file (Image or PDF)',
            color: AppColors.secondary,
            bgColor: Color(0xFFD6EEF4),
            onTap: () => onPick(DocumentPickerSource.files),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _UploadOptionTile extends StatelessWidget {
  const _UploadOptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  final dynamic icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.neutral200.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: HugeIcon(icon: icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.neutral200,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
