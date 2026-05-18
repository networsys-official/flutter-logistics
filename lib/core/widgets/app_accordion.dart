// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

/// A single animated accordion tile inspired by Klarna's clean accordion UI.
///
/// Features:
/// - Smooth expand/collapse animation with animated chevron rotation
/// - Leading icon (supports HugeIcons path data or standard [IconData])
///   rendered inside a soft-tinted rounded container
/// - Trailing badge pill for item counts
/// - White card surface with subtle shadow and large border radius
/// - Body revealed via [SizeTransition] + [FadeTransition]
///
/// Basic usage:
/// ```dart
/// AppAccordion(
///   title: 'Booking Requests',
///   accentColor: AppColors.primary,
///   leadingIcon: HugeIcons.strokeRoundedPackage,
///   badge: '2',
///   body: Column(children: [...]),
/// )
/// ```
class AppAccordion extends StatefulWidget {
  const AppAccordion({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.leadingIcon,
    this.leadingIconColor,
    this.accentColor = AppColors.primary,
    this.badge,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  /// Primary header label.
  final String title;

  /// Optional subtitle shown below the title in the header.
  final String? subtitle;

  /// Icon path data from HugeIcons or any [IconData]. Rendered inside a
  /// soft-tinted container matching [accentColor].
  final dynamic leadingIcon;

  /// Explicit color for [leadingIcon]. Defaults to [accentColor].
  final Color? leadingIconColor;

  /// Accent color applied to the icon tint, badge, and ink-splash.
  final Color accentColor;

  /// Short label shown inside a trailing pill (e.g. item count).
  final String? badge;

  /// Content revealed when the tile expands.
  final Widget body;

  /// Whether the accordion starts expanded.
  final bool initiallyExpanded;

  /// Called whenever the expanded state changes.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _chevronTurns;
  late Animation<double> _sizeFactor;
  late Animation<double> _fadeValue;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _chevronTurns = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _sizeFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _fadeValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _controller.forward() : _controller.reverse();
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.leadingIconColor ?? widget.accentColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppSpacing.shadowSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tappable header ───────────────────────────────────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              splashColor: widget.accentColor.withValues(alpha: 0.06),
              highlightColor: widget.accentColor.withValues(alpha: 0.03),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    // Leading icon
                    if (widget.leadingIcon != null) ...[
                      _AccordionLeadingIcon(
                        icon: widget.leadingIcon,
                        color: iconColor,
                        accentColor: widget.accentColor,
                      ),
                      const SizedBox(width: AppSpacing.sm + 2),
                    ],

                    // Title / subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral900,
                              height: 1.2,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.neutral500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: AppSpacing.sm),

                    // Badge pill
                    if (widget.badge != null) ...[
                      _AccordionBadge(
                        label: widget.badge!,
                        color: widget.accentColor,
                      ),
                      const SizedBox(width: AppSpacing.xs + 2),
                    ],

                    // Animated chevron
                    RotationTransition(
                      turns: _chevronTurns,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.neutral500,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Animated expanded body ────────────────────────────────────────
          SizeTransition(
            sizeFactor: _sizeFactor,
            axisAlignment: -1,
            child: FadeTransition(
              opacity: _fadeValue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thin divider between header and body
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    color: AppColors.neutral100,
                  ),
                  widget.body,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private sub-widgets ─────────────────────────────────────────────────────

/// Tinted square container housing the accordion's leading icon.
class _AccordionLeadingIcon extends StatelessWidget {
  const _AccordionLeadingIcon({
    required this.icon,
    required this.color,
    required this.accentColor,
  });

  final dynamic icon;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: HugeIcon(icon: icon, color: color, size: 22),
      ),
    );
  }
}

/// Small pill badge with a translucent background and bold label.
class _AccordionBadge extends StatelessWidget {
  const _AccordionBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── AppAccordionSection ─────────────────────────────────────────────────────

/// Groups multiple [AppAccordion] tiles under a Klarna-style labeled section.
///
/// The [label] is rendered as a small uppercase/semibold section heading,
/// followed by the provided [children] — typically [AppAccordion] tiles.
///
/// Usage:
/// ```dart
/// AppAccordionSection(
///   label: 'ACTIVE SHIPMENTS',
///   children: [
///     AppAccordion(title: 'Booking Requests', ...),
///     AppAccordion(title: 'Invoiced', ...),
///   ],
/// )
/// ```
class AppAccordionSection extends StatelessWidget {
  const AppAccordionSection({
    super.key,
    required this.label,
    required this.children,
    this.bottomSpacing = AppSpacing.lg,
  });

  final String label;
  final List<Widget> children;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AccordionSectionLabel(label: label),
          const SizedBox(height: AppSpacing.sm + 4),
          ...children,
        ],
      ),
    );
  }
}

/// Small uppercase section label styled to match the app's caption scale.
class _AccordionSectionLabel extends StatelessWidget {
  const _AccordionSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.neutral500,
        letterSpacing: 0.8,
      ),
    );
  }
}
