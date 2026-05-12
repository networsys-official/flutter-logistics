import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class AvatarSection extends StatelessWidget {
  final File? imageFile;
  final String? profileImageUrl;
  final VoidCallback onPickImage;

  const AvatarSection({
    super.key,
    required this.imageFile,
    required this.profileImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      if (profileImageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(profileImageUrl!);
      } else {
        // Prepend host if relative path
        final baseUrl = ApiEndpoints.configuredBaseUrl.replaceFirst(
          '/api/v1',
          '',
        );
        imageProvider = NetworkImage('$baseUrl$profileImageUrl');
      }
    } else {
      imageProvider = const AssetImage(AppImages.userProfile);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neutral200, width: 1),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: AppColors.secondaryContainer,
              backgroundImage: imageProvider,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCamera01,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
