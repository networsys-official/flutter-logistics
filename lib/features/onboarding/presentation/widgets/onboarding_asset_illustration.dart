import 'package:flutter/material.dart';

class OnboardingAssetIllustration extends StatelessWidget {
  const OnboardingAssetIllustration({
    super.key,
    required this.imagePath,
    this.maxWidth = 240,
    this.maxHeight = 220,
  });

  final String imagePath;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }
}
