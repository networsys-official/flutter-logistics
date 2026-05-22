import 'package:flutter/material.dart';

import 'package:logistic_by_strom/core/theme/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isEnabled ? colorScheme.surface : colorScheme.surfaceContainerHighest.withOpacity(0.45),
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(
            color: isEnabled ? colorScheme.outline.withOpacity(0.35) : colorScheme.outline.withOpacity(0.18),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ).copyWith(overlayColor: WidgetStateProperty.all(colorScheme.primary.withOpacity(0.06))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleBadge(),
            const SizedBox(width: 12),
            Text(
              'Login with Google',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleBadge extends StatelessWidget {
  const _GoogleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: const Text(
        'G',
        style: TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.w800, color: Color(0xFF4285F4)),
      ),
    );
  }
}
