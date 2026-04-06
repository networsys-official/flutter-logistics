import 'package:flutter/material.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';

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
                AppTheme.space4,
                AppTheme.space6,
                AppTheme.space4,
                AppTheme.space5,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
