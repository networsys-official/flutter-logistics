import 'package:flutter/material.dart';




class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: SafeArea(child: child),
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: currentIndex,
      //   indicatorColor: AppColors.secondaryContainer,
      //   onDestinationSelected: (index) {
      //     context.go(AppRoutes.bottomNavLocations[index]);
      //   },
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.space_dashboard_outlined),
      //       selectedIcon: Icon(Icons.space_dashboard_rounded),
      //       label: 'Dashboard',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.local_shipping_outlined),
      //       selectedIcon: Icon(Icons.local_shipping_rounded),
      //       label: 'Shipments',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.settings_outlined),
      //       selectedIcon: Icon(Icons.settings_rounded),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }
}
