import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class ShipmentUploadSection extends StatelessWidget {
  const ShipmentUploadSection({
    super.key,
    required this.documents,
    required this.onUploadTap,
    required this.onRemoveDocument,
    this.errorText,
  });

  final List<File> documents;
  final VoidCallback onUploadTap;
  final ValueChanged<int> onRemoveDocument;
  final String? errorText;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onUploadTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null
                    ? Colors.red
                    : AppColors.primary.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedUpload01,
                  color: AppColors.primary,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Upload Receipt',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
        if (documents.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            documents.length,
                (index) => SelectedDocumentTile(
                  file: documents[index],
                  onRemove: () => onRemoveDocument(index),
                ),
          ),
        ],
      ],
    );
  }
}

class SelectedDocumentTile extends StatelessWidget {
  const SelectedDocumentTile({
    super.key,
    required this.file,
    required this.onRemove,
  });

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neutral200.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: AppColors.neutral500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.path.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: AppColors.error, size: 20),
          ),
        ],
      ),
    );
  }
}
