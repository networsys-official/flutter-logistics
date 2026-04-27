import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/shared/widgets/app_bottom_nav.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: navigationShell,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the center FAB
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
