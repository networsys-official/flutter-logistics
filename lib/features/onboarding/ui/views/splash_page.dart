import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logistic_by_strom/core/constants/app_images.dart';

import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.paddingHorizontalMd,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: const _BrandMark(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppImages.logo, fit: BoxFit.contain);
  }
}
