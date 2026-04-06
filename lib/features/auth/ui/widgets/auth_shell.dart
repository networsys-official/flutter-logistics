import 'package:flutter/material.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_spacing.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.child,
    this.appBar,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar,
      body: SafeArea(
        top: appBar == null,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space4,
                AppSpacing.space6,
                AppSpacing.space4,
                AppSpacing.space5,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
