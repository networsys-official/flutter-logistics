import 'package:flutter/material.dart';

import 'package:logistic_by_strom/core/constants/app_images.dart';

class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 230),
          child: Image.asset(AppImages.logo, fit: BoxFit.scaleDown),
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: textTheme.displayMedium,
          ),
        ],
      ],
    );
  }
}
