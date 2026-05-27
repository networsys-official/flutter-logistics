import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    this.onPressed,
    this.text = 'Login with Google',
  });

  final VoidCallback? onPressed;
  final String text;

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
          backgroundColor: isEnabled
              ? Colors.white
              : Colors.white.withValues(alpha: 0.6),
          foregroundColor: const Color(0xFF3C4043),
          side: BorderSide(
            color: isEnabled
                ? const Color(0xFFDADCE0)
                : const Color(0xFFDADCE0).withValues(alpha: 0.5),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleBadge(),
            const SizedBox(width: 14),
            Text(
              text,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: isEnabled
                    ? const Color(0xFF3C4043)
                    : const Color(0xFF3C4043).withValues(alpha: 0.5),
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
    return SizedBox(
      width: 22,
      height: 22,
      child: SvgPicture.asset(
        'assets/svg/google_icon.svg',
        width: 22,
        height: 22,
      ),
    );
  }
}
