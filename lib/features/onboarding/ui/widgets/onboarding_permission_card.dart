import 'package:flutter/material.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';

class OnboardingPermissionCard extends StatelessWidget {
  const OnboardingPermissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 28,
                    color: Color(0xFF212121),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Allow Logistic Systems to access this device\'s location all-the-time?',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'App currently can access location only while you\'re using the app.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5B5B5B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const _PermissionAction(label: 'Allow all the time'),
            const Divider(height: 1),
            const _PermissionAction(label: 'Keep while-in-use access'),
            const Divider(height: 1),
            const _PermissionAction(label: 'Keep and don\'t ask again'),
          ],
        ),
      ),
    );
  }
}

class _PermissionAction extends StatelessWidget {
  const _PermissionAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF5A8DFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
