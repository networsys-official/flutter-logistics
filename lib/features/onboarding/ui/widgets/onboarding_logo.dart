import 'package:flutter/material.dart';

import 'package:logistic_by_strom/core/constants/app_images.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: 0.94,
        child: Image.asset(AppImages.logo, width: 118, fit: BoxFit.contain),
      ),
    );
  }
}
