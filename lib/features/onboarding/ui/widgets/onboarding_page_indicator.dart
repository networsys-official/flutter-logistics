import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 36 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1B1B1B) : const Color(0xFFB6B6B6),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
