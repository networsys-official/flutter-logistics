import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_body.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_fab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      extendBody: true,
      body: Column(
        children: [
          const HomeAppBar(),
          const Expanded(
            child: HomeBody(),
          ),
        ],
      ),
      floatingActionButton: const HomeFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
